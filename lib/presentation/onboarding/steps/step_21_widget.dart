import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step21Widget extends OnboardingStep {
  const Step21Widget();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Your life, always in sight.',
      subtitle:
          'Add your grid to your Home Screen, your Lock Screen, or your walls \u2014 a beautiful, constant reminder to live on purpose.',
      illustration:
          OnboardingIllustrationPlaceholder(name: 'Widget + Wallpaper example'),
    );
  }
}
