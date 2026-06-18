import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';

/// Listens for newly unlocked rewards and clears the pending celebration flag.
///
/// UI for milestone celebrations will be added in a follow-up.
class RewardsCelebrationListener extends StatefulWidget {
  const RewardsCelebrationListener({super.key, required this.child});

  final Widget child;

  @override
  State<RewardsCelebrationListener> createState() => _RewardsCelebrationListenerState();
}

class _RewardsCelebrationListenerState extends State<RewardsCelebrationListener> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _RewardsCelebrationGate>(
      converter: _RewardsCelebrationGate.fromStore,
      onInitialBuild: _onPendingRewards,
      onWillChange: (previous, next) {
        if (next.pendingCelebration.isNotEmpty &&
            previous?.pendingCelebration != next.pendingCelebration) {
          _onPendingRewards(next);
        }
      },
      builder: (context, _) => widget.child,
    );
  }

  void _onPendingRewards(_RewardsCelebrationGate gate) {
    if (gate.pendingCelebration.isEmpty) return;
    // TODO: show milestone celebration sheet when UI is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      StoreProvider.of<AppState>(context, listen: false).dispatch(
        const RewardsCelebrationDismissedAction(),
      );
    });
  }
}

class _RewardsCelebrationGate {
  const _RewardsCelebrationGate({required this.pendingCelebration});

  final Set<RewardId> pendingCelebration;

  static _RewardsCelebrationGate fromStore(Store<AppState> store) {
    return _RewardsCelebrationGate(
      pendingCelebration: store.state.rewardsState.pendingCelebration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RewardsCelebrationGate &&
          other.pendingCelebration.length == pendingCelebration.length &&
          other.pendingCelebration.containsAll(pendingCelebration);

  @override
  int get hashCode => Object.hashAllUnordered(pendingCelebration);
}
