import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step11LovedOne extends OnboardingStep {
  const Step11LovedOne();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Think about someone you love.',
      subtitle:
          'If you see them twice a year, and you\u2019re both in good health, you might have around [X] more visits together in your lifetime.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Mascot hug'),
    );
  }
}
