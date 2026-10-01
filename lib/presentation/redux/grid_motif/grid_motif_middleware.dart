import 'package:redux/redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';

class GridMotifMiddleware extends MiddlewareClass<AppState> {
  GridMotifMiddleware({required this.gridMotifRepository});

  final GridMotifRepository gridMotifRepository;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction || action is DataRestoredAction) {
      final selectedMotif = await gridMotifRepository.getSelectedMotif();
      try {
        store.dispatch(
          GridMotifLoadedAction(
            selectedMotif: selectedMotif,
            unlockedMotifs: store.state.gridMotifState.unlockedMotifs,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SetGridMotifAction) {
      if (!store.state.gridMotifState.unlockedMotifs.contains(action.motifId)) return;
      await gridMotifRepository.setSelectedMotif(action.motifId);
      try {
        store.dispatch(
          GridMotifLoadedAction(
            selectedMotif: action.motifId,
            unlockedMotifs: store.state.gridMotifState.unlockedMotifs,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is RewardsLoadedAction) {
      await _syncUnlocked(store, action.unlocked);
    }

    if (action is PurchaseSucceededAction) {
      await _syncUnlocked(store, store.state.rewardsState.unlocked);
    }
  }

  /// Pro unlocks every motif; otherwise streak rewards decide.
  Future<void> _syncUnlocked(Store<AppState> store, Set<RewardId> rewards) async {
    final purchase = store.state.purchaseState;
    final unlockedMotifs = purchase.isPro
        ? GridMotifId.all.toSet()
        : {
            ...GridMotifId.alwaysUnlocked,
            ...rewardIdsToGridMotifIds(rewards),
          };
    final persisted = await gridMotifRepository.getSelectedMotif();
    // Only fall back once the entitlement is known: while RevenueCat is still
    // loading, a Pro user's motif must survive the launch.
    final keepsPersisted = unlockedMotifs.contains(persisted) || !purchase.isResolved;
    final selected = keepsPersisted
        ? persisted
        : unlockedMotifs.contains(store.state.gridMotifState.selectedMotif)
            ? store.state.gridMotifState.selectedMotif
            : GridMotifId.dots;
    try {
      store.dispatch(GridMotifsUnlockedAction(unlockedMotifs));
      if (!keepsPersisted) {
        await gridMotifRepository.setSelectedMotif(selected);
      }
      store.dispatch(
        GridMotifLoadedAction(
          selectedMotif: selected,
          unlockedMotifs: unlockedMotifs,
        ),
      );
    } catch (_) {
      // Store torn down (e.g. in tests) during the async gap.
    }
  }
}
