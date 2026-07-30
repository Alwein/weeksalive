import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/year_grid_illustration.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step21WeeksDisappear extends OnboardingStep {
  const Step21WeeksDisappear();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final bgColor = AppColors.bg(context);

    final now = DateTime.now();
    final int dayOfYear = dayOfYearIndex(now) + 1;
    final int daysLived = dayOfYear;

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
                        Texts.onboardingXlBold(Strings.onboarding13Title),
                        const SizedBox(height: Margins.spacingM),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            YearGridIllustration(
                              animationDurationMs: 1500,
                              header: Texts.primaryXsCounter(
                                context,
                                Strings.thisYearLabel,
                                DateTime.now().year.toString(),
                              ),
                              filledCount: daysLived,
                              wheightDistribution: const [0, 1, 2, 2, 3, 3, 4, 4, 4],
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
