import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/paywall/paywall_page.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

class Step26Paywall extends OnboardingStep {
  const Step26Paywall();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

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
    final isPro = StoreProvider.of<AppState>(context).state.purchaseState.isPro;
    if (!isPro) {
      await Navigator.of(context).push<bool>(PaywallPage.route());
    }
    Future.delayed(const Duration(milliseconds: 300), () => _next());
  }

  void _next() {
    if (mounted) OnboardingScope.of(context).goNext();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
