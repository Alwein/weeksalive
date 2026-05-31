import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step24NotificationTime extends OnboardingStep {
  const Step24NotificationTime();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onPrimary => (context, controller) async {
    StoreProvider.of<AppState>(context, listen: false).dispatch(const RequestNotificationPermissionAction());
    await controller.goNext();
  };

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Center(
                    child: _NotificationAnimation(),
                  ),
                ),
                const SizedBox(height: Margins.spacingL),
                Texts.xlBold(Strings.onboarding20Title),
                const SizedBox(height: Margins.spacingM),
                const _NotificationTimeSelector(),
                const SizedBox(height: Margins.spacingM),
                const SmallDivider(),
                const SizedBox(height: Margins.spacingBase),
                Texts.primaryMediumSoft(context, Strings.onboarding20Subtitle),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTimeSelector extends StatelessWidget {
  const _NotificationTimeSelector();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NotificationSlotCard(
          slot: controller.slot1,
          onToggle: controller.toggleSlot1,
          onTimeChanged: controller.setSlot1Time,
        ),
        const SizedBox(height: Margins.spacingS),
        _NotificationSlotCard(
          slot: controller.slot2,
          onToggle: controller.toggleSlot2,
          onTimeChanged: controller.setSlot2Time,
        ),
      ],
    );
  }
}

class _NotificationSlotCard extends StatelessWidget {
  const _NotificationSlotCard({
    required this.slot,
    required this.onToggle,
    required this.onTimeChanged,
  });

  final NotificationSlotState slot;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimeChanged;

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: slot.time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingBase,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgSoft(context),
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.onboarding20CheckIn,
                    style: TextStyles.primarySmallBold.copyWith(
                      color: AppColors.contentSoftOnSoft(context),
                    ),
                  ),
                  const SizedBox(height: Margins.spacingXs),
                  Row(
                    children: [
                      Text(
                        _formatTime(slot.time),
                        style: TextStyles.primaryLargeBold.copyWith(
                          color: AppColors.content(context),
                        ),
                      ),
                      const SizedBox(width: Margins.spacingS),
                      Icon(
                        MingCuteIcons.mgc_pencil_line,
                        size: Dimens.iconSizeXs,
                        color: AppColors.contentSoft(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: slot.enabled,
              onChanged: onToggle,
              activeTrackColor: AppColors.greenSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationAnimation extends StatelessWidget {
  const _NotificationAnimation();

  @override
  Widget build(BuildContext context) {
    return const SlidingNotification();
  }
}

class SlidingNotification extends StatefulWidget {
  const SlidingNotification({super.key});
  @override
  State<SlidingNotification> createState() => _SlidingNotificationState();
}

class _SlidingNotificationState extends State<SlidingNotification> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _notificationOpacityAnimation;
  late Animation<Offset> _notificationSlideAnimation;
  late CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _curve = CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack);
    _notificationOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_curve);
    _notificationSlideAnimation = Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(_curve);
    _playAnimation();
  }

  Future<void> _playAnimation() async {
    if (!mounted) return;
    // empty screen
    await Future.delayed(const Duration(milliseconds: 700));
    // make notification appear
    if (mounted) {
      _animationController.forward();
    }
    // display notification for 2 seconds
    await Future.delayed(const Duration(seconds: 5), () {});
    // short delay before notification disappear
    await Future.delayed(const Duration(milliseconds: 500));
    // make notification disappear
    if (mounted) {
      _animationController.reverse();
    }
    // short delay before notification reappear
    await Future.delayed(const Duration(milliseconds: 1000));
    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _notificationOpacityAnimation,
            child: SlideTransition(
              position: _notificationSlideAnimation,
              child: const OnboardingFakeNotification(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class OnboardingFakeNotification extends StatelessWidget {
  const OnboardingFakeNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingS),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Hero(
            tag: "onboarding_logo",
            child: Image.asset(
              "assets/images/weeksalive_logo.webp",
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          const Expanded(
            child: _NotificationText(),
          ),
        ],
      ),
    );
  }
}

class _NotificationText extends StatelessWidget {
  const _NotificationText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.onboardingNotificationTitle,
          style: const TextStyle(
            fontSize: FontSizes.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Strings.onboardingNotificationSubtitle,
          style: const TextStyle(
            fontSize: FontSizes.regular,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
