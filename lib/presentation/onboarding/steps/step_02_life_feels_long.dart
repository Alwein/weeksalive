import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step02LifeFeelsLong extends OnboardingStep {
  const Step02LifeFeelsLong();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Life feels long. Until it doesn\u2019t.',
      subtitle:
          'Most of us move through weeks without really feeling them, until we look back and wonder where the years went.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Mascot flying in the sky'),
    );
  }
}
