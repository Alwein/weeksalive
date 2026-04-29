import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step12VisitsVisualization extends OnboardingStep {
  const Step12VisitsVisualization();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'What [X] visits looks like in your grid.',
      subtitle:
          'This isn\u2019t meant to feel heavy. It\u2019s meant to make those visits feel like what they are \u2014 precious.',
      illustration:
          OnboardingIllustrationPlaceholder(name: 'Grid with dots highlights'),
    );
  }
}
