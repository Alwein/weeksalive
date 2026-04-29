import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step22Privacy extends OnboardingStep {
  const Step22Privacy();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Before we begin. Your data is yours.',
      subtitle:
          'It never leaves your device. No ads. No tracking. No data release. Works 100% offline. Subscriptions allow us to develop WeeksAlive without compromise and unlock tons of features for you.',
      illustration:
          OnboardingIllustrationPlaceholder(name: 'Mascot with a lock'),
    );
  }
}
