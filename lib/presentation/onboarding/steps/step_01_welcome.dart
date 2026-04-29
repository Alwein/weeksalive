import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step01Welcome extends OnboardingStep {
  const Step01Welcome();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'WeeksAlive',
      subtitle: 'A gentle reminder that your time is precious',
      illustration: OnboardingIllustrationPlaceholder(name: 'App logo'),
    );
  }
}
