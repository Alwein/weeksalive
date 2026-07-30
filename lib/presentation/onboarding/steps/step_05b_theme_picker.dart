import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/theme_picker.dart';

class Step05bThemePicker extends OnboardingStep {
  const Step05bThemePicker();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Margins.spacingM),
                Texts.onboardingXlBold(Strings.onboardingThemePickerTitle),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryMediumSoft(
                  context,
                  Strings.onboardingThemePickerSubtitle,
                ),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
          const ThemePicker(
            scope: ThemePickerScope.onboarding,
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}
