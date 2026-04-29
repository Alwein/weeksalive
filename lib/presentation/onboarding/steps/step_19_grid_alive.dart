import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step19GridAlive extends OnboardingStep {
  const Step19GridAlive();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return const OnboardingStepLayout(
      title: 'Watch your grid come alive.',
      subtitle:
          'Every day you check in, your grid fills with color and meaning. Over time, you won\u2019t just see time passing \u2014 you\u2019ll see a life being lived.',
      illustration: OnboardingIllustrationPlaceholder(
        name: 'Grid view of year with completions',
      ),
      footer: Text('A day noticed is a day that stays.'),
    );
  }
}
