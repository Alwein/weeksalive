import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_step_layout.dart';

class Step08Lifespan extends OnboardingStep {
  const Step08Lifespan();

  @override
  String primaryLabel(BuildContext context) => 'Show me my grid';

  @override
  String? secondaryLabel(BuildContext context) =>
      'Feel lost? Answer 5 questions to estimate it';

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return OnboardingStepLayout(
      title: 'What is your projected lifespan?',
      subtitle: 'This is only an estimate, you can change it anytime.',
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${controller.lifespan} years'),
          Slider(
            min: 60,
            max: 120,
            divisions: 60,
            value: controller.lifespan.toDouble().clamp(60, 120),
            onChanged: (v) => controller.setLifespan(v.round()),
          ),
        ],
      ),
      footer: const Text(
        'Average life expectancy for [men/women] in [country] is [~85 years].',
      ),
    );
  }
}
