import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step15WeeksThatStay extends OnboardingStep {
  const Step15WeeksThatStay();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Some weeks feel like years. Others vanish like days.',
      illustration: OnboardingIllustrationPlaceholder(
        name: 'Week that stayed vs Week that faded',
      ),
      footer: Text(
        'The difference between them isn\u2019t luck. It\u2019s awareness \u2014 the simple act of deciding to show up.',
      ),
    );
  }
}
