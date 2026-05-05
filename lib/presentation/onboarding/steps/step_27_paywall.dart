import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

class Step27OnboardingDone extends OnboardingStep {
  const Step27OnboardingDone();

  @override
  bool get hideBackButton => true;

  @override
  String primaryLabel(BuildContext context) => '';

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onPrimary => null;

  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
