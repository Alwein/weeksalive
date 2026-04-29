import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step24Rating extends OnboardingStep {
  const Step24Rating();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  /// Triggers native in-app rating prompt + goNext.
  @override
  Future<void> Function(BuildContext, OnboardingFormController)?
  get onPrimary => (context, controller) async {
        // TODO: show native rating prompt here.
        await controller.goNext();
      };

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'How are we doing?',
      illustration: OnboardingIllustrationPlaceholder(name: 'Social proof'),
    );
  }
}
