import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step17DailyHabit extends OnboardingStep {
  const Step17DailyHabit();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Make living a real daily habit. Build a streak, one day at a time.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Mascot meditating'),
      footer: Text('???'),
    );
  }
}
