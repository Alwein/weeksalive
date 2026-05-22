import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/year_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step13WeeksDisappear extends OnboardingStep {
  const Step13WeeksDisappear();

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
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: Margins.spacingS),
                        Texts.xlBold(Strings.onboarding13Title),
                        const SizedBox(height: Margins.spacingS),
                        Texts.primaryMediumSoft(context, Strings.onboarding13Subtitle),
                        const SizedBox(height: Margins.spacingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            YearGridIllustration(
                              animationDurationMs: 2000,
                              header: Texts.primaryXsCounter(
                                context,
                                Strings.lastYearWeeksLabel,
                                '365 ${Strings.daysLabel}',
                              ),
                              filledCount: 365,
                              wheightDistribution: const [-1, -1, -1, -1, -1, -1, 4, -1, -1, -1, -1, -1, -1],
                            ),
                          ],
                        ),
                        const SizedBox(height: Margins.spacingM),
                      ],
                    ),
                  ),
                ),
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
              const SizedBox(height: Margins.spacingM),
              Texts.primaryMediumSoft(context, Strings.onboarding13Footer),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        ),
      ],
    );
  }
}
