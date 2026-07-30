import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/highlighted_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step12Birthdays extends OnboardingStep {
  const Step12Birthdays();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final grid = controller.lifeWeekGrid;
    final bgColor = AppColors.bg(context);

    final dots = birthdayDotIndices(
      totalWeeks: grid.totalWeeks,
      livedWeeks: grid.livedWeeks,
    );
    final birthdaysAhead = dots.ahead.length;
    final livedCount = controller.currentAge;
    final aheadCount = (controller.lifespan - controller.currentAge).clamp(0, controller.lifespan);

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
                  Texts.onboardingXlBold(Strings.onboarding09BirthdaysTitle(birthdaysAhead)),
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
                          Texts.primaryXsCounter(context, Strings.livedLabel, livedCount.toString()),
                          Texts.primaryXsCounter(context, Strings.aheadLabel, aheadCount.toString()),
                        ],
                      ),
                      animationDurationMs: 1000,
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
