import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/profile/pages/notifications_settings/notifications_settings_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/widgets/notification_slot_card.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
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

class _NotificationsSettingsBodyState extends State<_NotificationsSettingsBody> {
  late NotificationSlots _slots;

  @override
  void initState() {
    super.initState();
    _slots = NotificationSlots(
      slot1: widget.viewModel.dailySlot1,
      slot2: widget.viewModel.dailySlot2,
    );
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
          Texts.primaryRegularMedium(
            Strings.notificationsSettingsPageDailySlots,
            color: AppColors.contentSoft(context),
          ),
          const SizedBox(height: Margins.spacingBase),
          NotificationSlotCard(
            slot: _slots.slot1,
            onToggle: (value) => _updateSlots(
              _slots.copyWith(slot1: _slots.slot1.copyWith(enabled: value)),
            ),
            onTimeChanged: (time) => _updateSlots(
              _slots.copyWith(slot1: _slots.slot1.copyWith(time: time, enabled: true)),
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          NotificationSlotCard(
            slot: _slots.slot2,
            onToggle: (value) => _updateSlots(
              _slots.copyWith(slot2: _slots.slot2.copyWith(enabled: value)),
            ),
            onTimeChanged: (time) => _updateSlots(
              _slots.copyWith(slot2: _slots.slot2.copyWith(time: time, enabled: true)),
            ),
          ),
        ],
      ),
    );
  }
}
