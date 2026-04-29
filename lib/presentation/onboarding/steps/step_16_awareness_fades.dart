import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step16AwarenessFades extends OnboardingStep {
  const Step16AwarenessFades();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Awareness is beautiful. But it fades without a ritual.',
      illustration: OnboardingIllustrationPlaceholder(name: 'Mascot fading'),
      footer: Text(
        'That\u2019s why we built something simple: to help you stay present, not just today, but every week of your life.',
      ),
    );
  }
}
