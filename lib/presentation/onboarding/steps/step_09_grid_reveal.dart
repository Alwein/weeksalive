import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_illustration_placeholder.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step09GridReveal extends OnboardingStep {
  const Step09GridReveal();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final name = controller.name ?? 'You';
    return OnboardingStepLayout(
      title: 'This is $name\u2019s life in weeks.',
      subtitle:
          'Every square is a week. The dark ones you\u2019ve already lived.',
      illustration: const OnboardingIllustrationPlaceholder(name: 'Life grid'),
      footer: const Text('1862 weeks lived, 2812 still ahead.'),
    );
  }
}
