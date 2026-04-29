import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';
import 'package:weeksalive/presentation/widgets/custom_text_field.dart';

class Step05Name extends OnboardingStep {
  const Step05Name();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  bool canContinue(OnboardingFormController controller) =>
      (controller.name ?? '').trim().isNotEmpty;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return OnboardingStepLayout(
      title: 'How should we call you?',
      illustration: const OnboardingIllustrationPlaceholder(
        name: 'Mascot standing with name above his head',
      ),
      input: CustomTextField(
        hintText: 'Nickname',
        initialValue: controller.name,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        maxLength: 30,
        onChanged: controller.setName,
      ),
    );
  }
}
