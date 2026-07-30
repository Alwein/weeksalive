import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step17ButAddLife extends OnboardingStep {
  const Step17ButAddLife();

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
          Expanded(
            flex: 16,
            child: Center(
              child: SingleChildScrollView(
                child: OnboardingStaggeredColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Texts.onboardingXlBoldSoft(context, Strings.onboardingButAddLifeTitle1),
                    Text(
                      Strings.onboardingButAddLifeBut,
                      style: TextStyles.onboardingXxlBold.copyWith(color: AppColors.content(context)),
                    ),
                    Texts.onboardingXlBold(Strings.onboardingButAddLifeTitle2),
                  ],
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_looking_up.riv",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
