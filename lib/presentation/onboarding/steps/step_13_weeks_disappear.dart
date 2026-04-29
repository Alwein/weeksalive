import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step13WeeksDisappear extends OnboardingStep {
  const Step13WeeksDisappear();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Most weeks disappear.',
      subtitle:
          'Think about last year. How many weeks can you actually name?',
      illustration: OnboardingIllustrationPlaceholder(
        name: 'Small grid with some squares highlighted',
      ),
      body: Text(
        'Most don\u2019t stand out because nothing made them worth noticing.',
      ),
      footer: Text('This one doesn\u2019t have to fade.'),
    );
  }
}
