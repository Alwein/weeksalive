import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step25Final extends OnboardingStep {
  const Step25Final();

  @override
  String primaryLabel(BuildContext context) => 'I\u2019m ready to begin';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title:
          'You have exactly one life. Every week, a new chance. To feel more. To love more.',
      footer: Text('This is that chance.'),
    );
  }
}
