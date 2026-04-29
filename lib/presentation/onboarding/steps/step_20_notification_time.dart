import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step20NotificationTime extends OnboardingStep {
  const Step20NotificationTime();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  bool canContinue(OnboardingFormController controller) =>
      controller.notificationTime != null;

  /// Triggers notification permission request + goNext.
  /// Hook up your permission plugin in the real implementation.
  @override
  Future<void> Function(BuildContext, OnboardingFormController)?
  get onPrimary => (context, controller) async {
        // TODO: request notification permission here.
        await controller.goNext();
      };

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return OnboardingStepLayout(
      title: 'What time of the day is best for you to check in?',
      subtitle:
          'WeeksAlive will send you a notification to complete today\u2019s entry.',
      illustration: const OnboardingIllustrationPlaceholder(
        name: 'Notification example',
      ),
      input: Wrap(
        spacing: 8,
        children: [
          for (final slot in NotificationSlot.values)
            ChoiceChip(
              label: Text(_label(slot)),
              selected: controller.notificationSlot == slot,
              onSelected: (_) async {
                if (slot == NotificationSlot.custom) {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: controller.customNotificationTime ??
                        TimeOfDay.now(),
                  );
                  if (picked != null) {
                    controller.setCustomNotificationTime(picked);
                  }
                } else {
                  controller.setNotificationSlot(slot);
                }
              },
            ),
        ],
      ),
    );
  }

  String _label(NotificationSlot slot) {
    switch (slot) {
      case NotificationSlot.morning:
        return '8 AM';
      case NotificationSlot.afternoon:
        return '2:30 PM';
      case NotificationSlot.evening:
        return '9 PM';
      case NotificationSlot.custom:
        return 'Custom';
    }
  }
}
