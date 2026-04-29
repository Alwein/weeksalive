import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';

/// Paywall step. It intentionally owns the whole screen and has no primary
/// button in the standard footer — the paywall widget itself handles
/// purchase / restore / dismiss actions, then calls back into the
/// onboarding completion logic (see OnboardingPage).
class Step26Paywall extends OnboardingStep {
  const Step26Paywall();

  @override
  bool get hideBackButton => true;

  @override
  String primaryLabel(BuildContext context) => '';

  @override
  Future<void> Function(BuildContext, OnboardingFormController)?
  get onPrimary => (context, controller) async {
        // The paywall widget handles its own CTAs. The shell will never
        // call this because the paywall step renders a fullscreen widget
        // that replaces the default footer.
      };

  @override
  Widget buildContent(BuildContext context) {
    // Placeholder — to be replaced by the real PaywallView.
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('[PAYWALL] — Integrate RevenueCat paywall here.'),
      ),
    );
  }
}
