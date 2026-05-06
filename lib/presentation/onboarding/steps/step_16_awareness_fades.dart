import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step16AwarenessFades extends OnboardingStep {
  const Step16AwarenessFades();

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
            flex: 14,
            child: Center(
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_fade.riv",
              ),
            ),
          ),
          Expanded(
            flex: 16,
            child: Center(
              child: SingleChildScrollView(
                child: OnboardingStaggeredColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Texts.xlBold(Strings.onboarding16Title1),
                    const SizedBox(height: Margins.spacingS),
                    Texts.xlBoldSoft(context, Strings.onboarding16Title2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: Margins.spacingM),
                        const SmallDivider(),
                        const SizedBox(height: Margins.spacingM),
                        Texts.primaryMediumSoft(context, Strings.onboarding16Subtitle),
                        const SizedBox(height: Margins.spacingM),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
