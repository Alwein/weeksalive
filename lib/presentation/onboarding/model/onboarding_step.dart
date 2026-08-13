import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

abstract class OnboardingStep {
  const OnboardingStep();

  /// Name this step is reported under in analytics, derived from the class name
  /// (`Step12Birthdays` becomes `step_12_birthdays`).
  ///
  /// Renaming a step class therefore renames a funnel step and splits its
  /// history; override this getter instead when a class has to be renamed.
  String get analyticsName => snakeCase(runtimeType.toString());

  Widget buildContent(BuildContext context);

  String primaryLabel(BuildContext context);

  bool canContinue(OnboardingFormController controller) => true;

  Future<void> Function(BuildContext context, OnboardingFormController controller)? get onPrimary => null;

  Future<void> Function(BuildContext context, OnboardingFormController controller)? get onSecondary => null;

  bool get hideBackButton => false;
}

/// `Step03bLifeInWeeks` -> `step_03b_life_in_weeks`.
String snakeCase(String value) {
  final buffer = StringBuffer();

  for (var i = 0; i < value.length; i++) {
    final character = value[i];
    final isBoundary = i > 0 &&
        (_isUpperCase(character) || (_isDigit(character) && !_isDigit(value[i - 1])));
    if (isBoundary) buffer.write('_');
    buffer.write(character.toLowerCase());
  }

  return buffer.toString();
}

bool _isUpperCase(String character) => character != character.toLowerCase();

bool _isDigit(String character) {
  final code = character.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39;
}
