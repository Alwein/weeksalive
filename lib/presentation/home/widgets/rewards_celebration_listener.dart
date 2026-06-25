import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/confetti_wrapper.dart';

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
    return ConfettiWrapper(
      builder: (context, confettiController) {
        return StoreConnector<AppState, _RewardsCelebrationGate>(
          converter: _RewardsCelebrationGate.fromStore,
          onInitialBuild: (gate) => _onPendingRewards(gate, confettiController),
          onWillChange: (previous, next) {
            if (next.pendingCelebration.isNotEmpty && previous?.pendingCelebration != next.pendingCelebration) {
              _onPendingRewards(next, confettiController);
            }
          },
          builder: (context, _) => widget.child,
        );
      },
    );
  }

  void _onPendingRewards(_RewardsCelebrationGate gate, ConfettiController confettiController) {
    if (gate.pendingCelebration.isEmpty) return;
    confettiController.play();
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
