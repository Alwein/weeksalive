import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step06DateOfBirth extends OnboardingStep {
  const Step06DateOfBirth();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  bool canContinue(OnboardingFormController controller) =>
      controller.dateOfBirth != null;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final date = controller.dateOfBirth;

    return OnboardingStepLayout(
      title: 'When did your story begin?',
      subtitle: 'We\u2019ll build your personal life grid from this moment.',
      input: _DateOfBirthPicker(
        value: date,
        onChanged: controller.setDateOfBirth,
      ),
    );
  }
}

class _DateOfBirthPicker extends StatelessWidget {
  const _DateOfBirthPicker({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    // Placeholder for the real date picker integration. The shell only needs
    // to know that tapping it updates the controller.
    return OutlinedButton(
      onPressed: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime(now.year - 30, now.month, now.day),
          firstDate: DateTime(1900),
          lastDate: now,
        );
        if (picked != null) onChanged(picked);
      },
      child: Text(value == null ? 'Select date of birth' : '$value'),
    );
  }
}
