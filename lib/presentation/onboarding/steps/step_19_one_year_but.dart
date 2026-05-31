import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/year_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step19OneYearBut extends OnboardingStep {
  const Step19OneYearBut();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final bgColor = AppColors.bg(context);

    final now = DateTime.now();
    final int georgianDays = daysInGregorianYear(now.year);
    final int dayOfYear = (now.difference(DateTime(now.year, 1, 1)).inDays + 1);
    final int daysLived = dayOfYear;
    final int daysAhead = georgianDays - dayOfYear;

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
                        Texts.xlBold(Strings.onboarding27OneYearButTitle(georgianDays)),
                        const SizedBox(height: Margins.spacingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                              child: YearGridIllustration(
                                animationDurationMs: 1000,
                                header: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Texts.primaryXsCounter(context, Strings.livedDaysLabel, daysLived.toString()),
                                    Texts.primaryXsCounter(context, Strings.aheadLabel, daysAhead.toString()),
                                  ],
                                ),
                                filledCount: daysLived,
                                wheightDistribution: const [2],
                              ),
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
      ],
    );
  }
}
