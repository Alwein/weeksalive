import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

abstract class OnboardingStep {
  const OnboardingStep();

  Widget buildContent(BuildContext context);

  String primaryLabel(BuildContext context);

  bool canContinue(OnboardingFormController controller) => true;

  Future<void> Function(BuildContext context, OnboardingFormController controller)? get onPrimary => null;

  Future<void> Function(BuildContext context, OnboardingFormController controller)? get onSecondary => null;

  bool get hideBackButton => false;
}
