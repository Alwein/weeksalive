import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_state.dart';

GridMotifState gridMotifReducer(GridMotifState state, dynamic action) {
  if (action is GridMotifLoadedAction) {
    final selected = action.unlockedMotifs.contains(action.selectedMotif)
        ? action.selectedMotif
        : GridMotifId.dots;
    return state.copyWith(
      selectedMotif: selected,
      unlockedMotifs: action.unlockedMotifs,
    );
  }

  if (action is SetGridMotifAction) {
    if (!state.unlockedMotifs.contains(action.motifId)) return state;
    return state.copyWith(selectedMotif: action.motifId);
  }

  if (action is GridMotifsUnlockedAction) {
    final unlocked = {...action.unlockedMotifs, ...GridMotifId.alwaysUnlocked};
    final selected = unlocked.contains(state.selectedMotif) ? state.selectedMotif : GridMotifId.dots;
    return state.copyWith(unlockedMotifs: unlocked, selectedMotif: selected);
  }

  return state;
}
