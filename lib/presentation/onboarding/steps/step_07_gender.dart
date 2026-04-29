import 'package:flutter/material.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step07Gender extends OnboardingStep {
  const Step07Gender();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  bool canContinue(OnboardingFormController controller) =>
      controller.gender != null;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return OnboardingStepLayout(
      title: 'Are you a man or a woman?',
      subtitle: 'Women tend to live 5 years longer than men.',
      input: Wrap(
        spacing: 8,
        children: [
          for (final g in Gender.values)
            ChoiceChip(
              label: Text(g.name),
              selected: controller.gender == g,
              onSelected: (_) => controller.setGender(g),
            ),
        ],
      ),
    );
  }
}
