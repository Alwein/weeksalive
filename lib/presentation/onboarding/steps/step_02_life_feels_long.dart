import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step02LifeFeelsLong extends OnboardingStep {
  const Step02LifeFeelsLong();

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
            flex: 10,
            child: Center(
              child: ParallaxRive(
                assetPath: "assets/animations/outline_floating.riv",
              ),
            ),
          ),
          Expanded(
            flex: 16,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: OnboardingStaggeredColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Texts.onboardingXlBold(Strings.onboarding02Title1),
                    Texts.onboardingXlBoldSoft(context, Strings.onboarding02Title2),
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
                          Strings.onboarding02Subtitle,
                        ),
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
