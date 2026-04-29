import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step23Attribution extends OnboardingStep {
  const Step23Attribution();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'One small favor?',
      subtitle:
          'We\u2019re a small team, and you just joined thousands of people using WeeksAlive. If you allow tracking on the next screen, it simply tells us which ad brought you here. Nothing personal, no data sold, ever. That one signal helps us find more people who need this app and keeps us building it for you.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Mascot shy'),
    );
  }
}
