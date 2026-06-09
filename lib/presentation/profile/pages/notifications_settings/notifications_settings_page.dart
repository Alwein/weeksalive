import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/profile/pages/notifications_settings/notifications_settings_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/widgets/notification_slot_card.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => const NotificationsSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.notificationsSettingsPageTitle),
      body: StoreConnector<AppState, NotificationsSettingsViewModel>(
        converter: (store) => NotificationsSettingsViewModel.create(store),
        builder: (context, viewModel) => _NotificationsSettingsBody(viewModel: viewModel),
      ),
    );
  }
}

class _NotificationsSettingsBody extends StatefulWidget {
  const _NotificationsSettingsBody({required this.viewModel});

  final NotificationsSettingsViewModel viewModel;

  @override
  State<_NotificationsSettingsBody> createState() => _NotificationsSettingsBodyState();
}

class _NotificationsSettingsBodyState extends State<_NotificationsSettingsBody> with WidgetsBindingObserver {
  late NotificationSlots _slots;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _slots = NotificationSlots(
      slot1: widget.viewModel.dailySlot1,
      slot2: widget.viewModel.dailySlot2,
      weeklySummary: widget.viewModel.weeklySummarySlot,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      StoreProvider.of<AppState>(context, listen: false).dispatch(
        const RefreshNotificationPermissionAction(),
      );
    }
  }

  void _updateSlots(NotificationSlots slots) {
    setState(() => _slots = slots);
    StoreProvider.of<AppState>(context, listen: false).dispatch(
      UpdateNotificationSettingsAction(slots),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingBase),
          if (!widget.viewModel.notificationsEnabled) ...[
            _NotificationsDisabledBanner(
              onOpenSettings: () => StoreProvider.of<AppState>(context, listen: false).dispatch(
                const OpenNotificationSettingsAction(),
              ),
            ),
            const SizedBox(height: Margins.spacingBase),
          ],
          Texts.primaryRegularMedium(
            Strings.notificationsSettingsPageDailySlots,
            color: AppColors.contentSoft(context),
          ),
          const SizedBox(height: Margins.spacingBase),
          NotificationSlotCard(
            enabled: widget.viewModel.notificationsEnabled,
            slot: _slots.slot1,
            label: Strings.notificationsSettingsPageDailySlot1,
            onToggle: (value) => _updateSlots(
              _slots.copyWith(slot1: _slots.slot1.copyWith(enabled: value)),
            ),
            onTimeChanged: (time) => _updateSlots(
              _slots.copyWith(slot1: _slots.slot1.copyWith(time: time, enabled: true)),
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          NotificationSlotCard(
            enabled: widget.viewModel.notificationsEnabled,
            slot: _slots.slot2,
            label: Strings.notificationsSettingsPageDailySlot2,
            onToggle: (value) => _updateSlots(
              _slots.copyWith(slot2: _slots.slot2.copyWith(enabled: value)),
            ),
            onTimeChanged: (time) => _updateSlots(
              _slots.copyWith(slot2: _slots.slot2.copyWith(time: time, enabled: true)),
            ),
          ),
          const SizedBox(height: Margins.spacingL),
          Texts.primaryRegularMedium(
            Strings.notificationsSettingsPageWeeklySlot,
            color: AppColors.contentSoft(context),
          ),
          const SizedBox(height: Margins.spacingBase),
          NotificationSlotCard(
            enabled: widget.viewModel.notificationsEnabled,
            slot: _slots.weeklySummary,
            label: Strings.notificationsSettingsPageWeeklySlotDay(
              Strings.weekdayFullNames[(widget.viewModel.weekStartDay - 1).clamp(0, 6)],
            ),
            onToggle: (value) => _updateSlots(
              _slots.copyWith(weeklySummary: _slots.weeklySummary.copyWith(enabled: value)),
            ),
            onTimeChanged: (time) => _updateSlots(
              _slots.copyWith(weeklySummary: _slots.weeklySummary.copyWith(time: time, enabled: true)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsDisabledBanner extends StatelessWidget {
  const _NotificationsDisabledBanner({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingM),
      decoration: BoxDecoration(
        color: AppColors.redWarning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        border: Border.all(color: AppColors.redWarning.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            MingCuteIcons.mgc_notification_off_line,
            color: AppColors.redWarning,
            size: Dimens.iconSizeM,
          ),
          const SizedBox(height: Margins.spacingM),
          Texts.primaryRegularMedium(
            Strings.notificationsSettingsPageDisabledMessage,
            color: AppColors.content(context),
          ),
          const SizedBox(height: Margins.spacingM),
          PrimaryButton(
            text: Strings.notificationsSettingsPageOpenSettings,
            onPressed: onOpenSettings,
          ),
        ],
      ),
    );
  }
}
