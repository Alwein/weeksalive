import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step10MakeItCount extends OnboardingStep {
  const Step10MakeItCount();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
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
                assetPath: "assets/animations/outline_sky.riv",
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
                  Texts.xlBold(Strings.onboarding10Title1),
                  const SizedBox(height: Margins.spacingS),
                  Texts.xlBoldSoft(context, Strings.onboarding10Title2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      const SmallDivider(),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(
                        context,
                        Strings.onboarding10Subtitle,
                      ),
                      const SizedBox(height: Margins.spacingBase),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
