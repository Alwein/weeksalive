import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step04BuildYourGrid extends OnboardingStep {
  const Step04BuildYourGrid();

  @override
  String primaryLabel(BuildContext context) => 'I\u2019m ready';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Let\u2019s build your own grid.',
      subtitle:
          'Your grid is unique. It starts the day you were born, and it belongs to no one else.',
      illustration:
          OnboardingIllustrationPlaceholder(name: 'Mascot standing with form in his hands'),
    );
  }
}
