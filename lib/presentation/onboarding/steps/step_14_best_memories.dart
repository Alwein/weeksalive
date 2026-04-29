import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step14BestMemories extends OnboardingStep {
  const Step14BestMemories();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Your best memories weren\u2019t planned.',
      subtitle:
          'They happened in ordinary weeks, to people who were paying attention.',
      body: Text(
        '- The afternoon you laughed until you cried\n'
        '- A quiet morning that asked nothing of you\n'
        '- The stranger who said exactly the right thing',
      ),
      footer: Text(
        'You never know the value of a moment until it becomes a memory.',
      ),
    );
  }
}
