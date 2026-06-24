import 'package:redux/redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';

class GridMotifMiddleware extends MiddlewareClass<AppState> {
  GridMotifMiddleware({required this.gridMotifRepository});

  final GridMotifRepository gridMotifRepository;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
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
      final unlockedMotifs = {
        ...GridMotifId.alwaysUnlocked,
        ...rewardIdsToGridMotifIds(action.unlocked),
      };
      final selected = store.state.gridMotifState.selectedMotif;
      try {
        store.dispatch(GridMotifsUnlockedAction(unlockedMotifs));
        if (!unlockedMotifs.contains(selected)) {
          await gridMotifRepository.setSelectedMotif(GridMotifId.dots);
          store.dispatch(
            GridMotifLoadedAction(
              selectedMotif: GridMotifId.dots,
              unlockedMotifs: unlockedMotifs,
            ),
          );
        }
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }
  }
}
