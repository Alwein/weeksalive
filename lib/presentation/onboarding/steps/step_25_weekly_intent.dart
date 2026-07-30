import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/weekly_intent_form_content.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step25WeeklyIntent extends OnboardingStep {
  const Step25WeeklyIntent();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _Step25Content();

  @override
  bool canContinue(OnboardingFormController controller) => controller.selectedIntentIds.isNotEmpty;
}

class _Step25Content extends StatelessWidget {
  const _Step25Content();

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Texts.onboardingXlBold(Strings.onboardingWeeklyIntentTitle),
                      const SizedBox(height: Margins.spacingS),
                      Texts.primaryMediumSoft(context, Strings.onboardingWeeklyIntentSubtitle),
                      const SizedBox(height: Margins.spacingL),
                      WeeklyIntentFormContent(
                        selectedIds: controller.selectedIntentIds,
                        onIntentToggled: controller.toggleIntent,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: Margins.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SmallDivider(),
                    const SizedBox(height: Margins.spacingM),
                    Texts.primaryMediumSoft(context, Strings.onboardingWeeklyIntentFooter),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
