import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_begin_picker.dart';

class Step08WeekBegin extends OnboardingStep {
  const Step08WeekBegin();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _Step08Content();
}

class _Step08Content extends StatelessWidget {
  const _Step08Content();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Texts.onboardingXlBold(Strings.onboardingWeekBeginTitle),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryMediumSoft(context, Strings.onboardingWeekBeginSubtitle),
                const SizedBox(height: Margins.spacingL),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return WeekBeginPicker(
                      dateOfBirth: controller.dateOfBirth,
                      initialChoice: WeekBeginChoice.monday,
                      selectedWeekStartDay: controller.weekStartDay,
                      onWeekStartDaySelected: controller.setWeekStartDay,
                    );
                  },
                ),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
