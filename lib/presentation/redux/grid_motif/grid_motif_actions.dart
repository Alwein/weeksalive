import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

class SetGridMotifAction {
  final GridMotifId motifId;
  const SetGridMotifAction(this.motifId);
}

class GridMotifLoadedAction {
  final GridMotifId selectedMotif;
  final Set<GridMotifId> unlockedMotifs;
  const GridMotifLoadedAction({
    required this.selectedMotif,
    required this.unlockedMotifs,
  });
}

class GridMotifsUnlockedAction {
  final Set<GridMotifId> unlockedMotifs;
  const GridMotifsUnlockedAction(this.unlockedMotifs);
}
