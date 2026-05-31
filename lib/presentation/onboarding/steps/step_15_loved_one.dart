import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step15LovedOne extends OnboardingStep {
  const Step15LovedOne();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final visits = controller.remainingVisits;

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
                assetPath: "assets/animations/outline_love.riv",
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
                  Texts.xlBold(Strings.onboarding11Title1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      const SmallDivider(),
                      const SizedBox(height: Margins.spacingM),
                      _Onboarding11Subtitle(visits: visits),
                      const SizedBox(height: Margins.spacingM),
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

class _Onboarding11Subtitle extends StatelessWidget {
  const _Onboarding11Subtitle({required this.visits});

  final int visits;

  @override
  Widget build(BuildContext context) {
    final contentColor = AppColors.content(context);
    final softColor = AppColors.contentSoft(context);
    final boldStyle = TextStyles.primaryMediumBold.copyWith(color: contentColor);
    final softStyle = TextStyles.primaryMediumMedium.copyWith(color: softColor);
    final boldText = "$visits more visits";

    final fullText = Strings.onboarding11Subtitle(visits);
    final boldIndex = fullText.indexOf(boldText);

    if (boldIndex == -1) {
      return Text(fullText, style: softStyle);
    }

    return RichText(
      text: TextSpan(
        style: softStyle,
        children: [
          TextSpan(text: fullText.substring(0, boldIndex)),
          TextSpan(text: boldText, style: boldStyle),
          TextSpan(text: fullText.substring(boldIndex + boldText.length)),
        ],
      ),
    );
  }
}
