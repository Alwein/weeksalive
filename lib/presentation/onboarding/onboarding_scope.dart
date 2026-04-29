import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

class OnboardingScope extends InheritedNotifier<OnboardingFormController> {
  const OnboardingScope({
    super.key,
    required OnboardingFormController controller,
    required super.child,
  }) : super(notifier: controller);

  static OnboardingFormController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'No OnboardingScope found in context');
    return scope!.notifier!;
  }

  static OnboardingFormController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'No OnboardingScope found in context');
    return scope!.notifier!;
  }
}
