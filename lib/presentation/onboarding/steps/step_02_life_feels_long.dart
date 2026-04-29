import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step02LifeFeelsLong extends OnboardingStep {
  const Step02LifeFeelsLong();

  @override
  String primaryLabel(BuildContext context) => 'Continue';

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColors.content(context),
                  BlendMode.srcIn,
                ),
                child: Lottie.asset(
                  "assets/animations/outline_floating.json",
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Texts.xlBold(Strings.onboarding02Title1),
                    Texts.xlBoldSoft(context, Strings.onboarding02Title2),
                    const SizedBox(height: Margins.spacingM),
                    const SmallDivider(),
                    const SizedBox(height: Margins.spacingM),
                    Texts.primaryMediumSoft(
                      context,
                      Strings.onboarding02Subtitle,
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
