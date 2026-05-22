import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/year_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step19GridAlive extends OnboardingStep {
  const Step19GridAlive();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final bgColor = AppColors.bg(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.0, 0.88, 1.0],
              colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
            ).createShader(rect),
            blendMode: BlendMode.dstOut,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texts.xlBold(Strings.onboarding19Title),
                  const SizedBox(height: Margins.spacingM),
                  Texts.primaryMediumSoft(context, Strings.onboarding19Subtitle),
                  const SizedBox(height: Margins.spacingM),
                  const YearGridIllustration(filledCount: 126, wheightDistribution: [0, 1, 2, 2, 3, 3, 4, 4, 4]),
                  const SizedBox(height: Margins.spacingM),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SmallDivider(),
              const SizedBox(height: Margins.spacingBase),
              Texts.primaryMediumSoft(context, Strings.onboarding19Footer),
              const SizedBox(height: Margins.spacingBase),
            ],
          ),
        ),
      ],
    );
  }
}
