import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step03LifeInWeeks extends OnboardingStep {
  const Step03LifeInWeeks();

  @override
  String primaryLabel(BuildContext context) => 'Get my grid';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Your life is made of weeks.',
      subtitle: 'Birthdays, heartbreaks. Ordinary Tuesdays. Every one is here.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Short life grid example'),
      footer: Text(
        'Every square is a week you lived, or a week still ahead of you. About 4000 in total.',
      ),
    );
  }
}
