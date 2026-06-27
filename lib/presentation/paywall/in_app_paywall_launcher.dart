import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/presentation/paywall/show_in_app_paywall.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

class InAppPaywallLauncher extends StatefulWidget {
  const InAppPaywallLauncher({super.key, required this.child});

  final Widget child;

  @override
  State<InAppPaywallLauncher> createState() => _InAppPaywallLauncherState();
}

class _InAppPaywallLauncherState extends State<InAppPaywallLauncher> {
  bool _launchPaywallScheduled = false;

  void _scheduleLaunchPaywallIfNeeded(_PaywallLaunchViewModel vm) {
    if (_launchPaywallScheduled || vm.isPro || !vm.isPurchaseResolved) return;

    _launchPaywallScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showInAppPaywall(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _PaywallLaunchViewModel>(
      converter: (store) => _PaywallLaunchViewModel(
        isPro: store.state.purchaseState.isPro,
        isPurchaseResolved: store.state.purchaseState.isResolved,
      ),
      distinct: true,
      builder: (context, vm) {
        _scheduleLaunchPaywallIfNeeded(vm);
        return widget.child;
      },
    );
  }
}

class _PaywallLaunchViewModel {
  const _PaywallLaunchViewModel({
    required this.isPro,
    required this.isPurchaseResolved,
  });

  final bool isPro;
  final bool isPurchaseResolved;

  @override
  bool operator ==(Object other) {
    return other is _PaywallLaunchViewModel && other.isPro == isPro && other.isPurchaseResolved == isPurchaseResolved;
  }

  @override
  int get hashCode => Object.hash(isPro, isPurchaseResolved);
}
