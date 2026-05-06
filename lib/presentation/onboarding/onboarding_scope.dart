import 'package:flutter/widgets.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

class OnboardingScope extends InheritedNotifier<OnboardingFormController> {
  const OnboardingScope({
    super.key,
    required OnboardingFormController controller,
    required this.onSubmit,
    required super.child,
  }) : super(notifier: controller);

  final VoidCallback onSubmit;

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

  static VoidCallback submitOf(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'No OnboardingScope found in context');
    return scope!.onSubmit;
  }
}
