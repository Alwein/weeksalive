import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/highlighted_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step18ThisYear extends OnboardingStep {
  const Step18ThisYear();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final grid = controller.lifeWeekGrid;
    final bgColor = AppColors.bg(context);
    final dots = currentYearDotIndices(
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
    );

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
                  Texts.onboardingXlBold(Strings.onboarding09dThisYearTitle),
                  const SizedBox(height: Margins.spacingM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                    child: HighlightedGridIllustration(
                      totalWeeks: grid.totalWeeks,
                      livedWeeks: grid.livedWeeks,
                      highlightedDots: [...dots.lived, ...dots.ahead],
                      caption: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texts.primaryXsCounter(context, Strings.thisYearLabel, DateTime.now().year.toString()),
                        ],
                      ),
                      animationDurationMs: 1000,
                      highlightColor: AppColors.accentOrange(context),
                    ),
                  ),
                  const SizedBox(height: Margins.spacingM),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
