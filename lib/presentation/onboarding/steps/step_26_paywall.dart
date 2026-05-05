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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(PaywallPage.route()).then((value) {
        if (mounted) {
          _next(context);
        }
      });
    });
  }

  void _next(BuildContext context) {
    final controller = OnboardingScope.of(context);
    controller.goNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
