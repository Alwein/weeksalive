import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/highlighted_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step09bWinters extends OnboardingStep {
  const Step09bWinters();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final grid = controller.lifeWeekGrid;
    final bgColor = AppColors.bg(context);

    final dots = winterDotIndices(
      dateOfBirth: controller.dateOfBirth,
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
    );
    final winterWeeksAhead = dots.ahead.length;
    final winterWeeksLived = dots.lived.length;

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
                  Texts.xlBold(Strings.onboarding09WintersTitle(winterWeeksAhead)),
                  const SizedBox(height: Margins.spacingM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                    child: HighlightedGridIllustration(
                      totalWeeks: grid.totalWeeks,
                      livedWeeks: grid.livedWeeks,
                      highlightedDots: dots.ahead,
                      livedCount: winterWeeksLived,
                      aheadCount: winterWeeksAhead,
                      animationDurationMs: 1000,
                      highlightColor: AppColors.accentMint,
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
