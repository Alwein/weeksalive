import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step18OneMinute extends OnboardingStep {
  const Step18OneMinute();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'One minute. Every day.',
      subtitle:
          'A quick check-in to notice how you\u2019re really living \u2014 before the day slips away.',
      illustration: OnboardingIllustrationPlaceholder(
        name: 'Mascot and example of completed day',
      ),
    );
  }
}
