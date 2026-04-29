import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step10MakeItCount extends OnboardingStep {
  const Step10MakeItCount();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title:
          'This isn\u2019t about counting time down. It\u2019s about making each week count.',
      subtitle:
          'WeeksAlive is about awareness, intention, and living with purpose.',
    );
  }
}
