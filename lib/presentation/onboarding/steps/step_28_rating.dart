import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step28Rating extends OnboardingStep {
  const Step28Rating();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _Step28Content();
}

class _Step28Content extends StatelessWidget {
  const _Step28Content();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_favor.riv",
              ),
            ),
          ),
          const SizedBox(height: Margins.spacingM),
          Center(
            child: SingleChildScrollView(
              child: OnboardingStaggeredColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts.onboardingXlBold(Strings.onboarding22Title1),
                  const SizedBox(height: Margins.spacingBase),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
