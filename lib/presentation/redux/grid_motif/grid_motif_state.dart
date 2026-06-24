import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

class GridMotifState {
  final GridMotifId selectedMotif;
  final Set<GridMotifId> unlockedMotifs;

  const GridMotifState({
    this.selectedMotif = GridMotifId.dots,
    Set<GridMotifId>? unlockedMotifs,
  }) : unlockedMotifs = unlockedMotifs ?? const {GridMotifId.dots, GridMotifId.squares};

  GridMotifState copyWith({
    GridMotifId? selectedMotif,
    Set<GridMotifId>? unlockedMotifs,
  }) {
    return GridMotifState(
      selectedMotif: selectedMotif ?? this.selectedMotif,
      unlockedMotifs: unlockedMotifs ?? this.unlockedMotifs,
    );
  }
}
