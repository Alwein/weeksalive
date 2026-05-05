import 'package:flutter/material.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/paywall/paywall_page.dart';

class Step26Paywall extends OnboardingStep {
  const Step26Paywall();

  @override
  bool get hideBackButton => true;

  @override
  String primaryLabel(BuildContext context) => '';

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onPrimary => null;

  @override
  Widget buildContent(BuildContext context) {
    return const _PaywallDisplayer();
  }
}

class _PaywallDisplayer extends StatefulWidget {
  const _PaywallDisplayer();

  @override
  State<_PaywallDisplayer> createState() => __PaywallDisplayerState();
}

class __PaywallDisplayerState extends State<_PaywallDisplayer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPaywall());
  }

  Future<void> _showPaywall() async {
    await Navigator.of(context).push<bool>(PaywallPage.route());
    if (mounted) _next();
  }

  void _next() => OnboardingScope.of(context).goNext();

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
