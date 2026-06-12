import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/highlighted_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step14Olympics extends OnboardingStep {
  const Step14Olympics();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final grid = controller.lifeWeekGrid;
    final bgColor = AppColors.bg(context);
    final dateOfBirth = controller.dateOfBirth;

    final dots = olympicsDotIndices(
      dateOfBirth: dateOfBirth,
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
    );

    const columns = 52;
    int countDistinctYears(List<int> indices) {
      if (dateOfBirth == null) return 0;
      final years = <int>{};
      for (final i in indices) {
        years.add(dateOfBirth.year + i ~/ columns);
      }
      return years.length;
    }

    final olympicsAhead = countDistinctYears(dots.ahead);
    final olympicsLived = countDistinctYears(dots.lived);

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
                  Texts.xlBold(Strings.onboarding09OlympicsTitle(olympicsAhead)),
                  const SizedBox(height: Margins.spacingM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                    child: HighlightedGridIllustration(
                      totalWeeks: grid.totalWeeks,
                      livedWeeks: grid.livedWeeks,
                      highlightedDots: dots.ahead,
                      caption: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texts.primaryXsCounter(context, Strings.livedLabel, olympicsLived.toString()),
                          Texts.primaryXsCounter(context, Strings.aheadLabel, olympicsAhead.toString()),
                        ],
                      ),
                      animationDurationMs: 1000,
                      highlightColor: AppColors.accentPurple(context),
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
