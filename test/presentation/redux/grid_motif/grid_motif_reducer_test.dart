import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_reducer.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_state.dart';

void main() {
  group('gridMotifReducer', () {
    const initial = GridMotifState();

    test('SetGridMotifAction updates selected when unlocked', () {
      final next = gridMotifReducer(
        initial,
        const SetGridMotifAction(GridMotifId.squares),
      );
      expect(next.selectedMotif, GridMotifId.squares);
    });

    test('SetGridMotifAction is ignored when locked', () {
      final next = gridMotifReducer(
        initial,
        const SetGridMotifAction(GridMotifId.flowers),
      );
      expect(next.selectedMotif, GridMotifId.dots);
    });

    test('GridMotifsUnlockedAction resets selection when needed', () {
      const state = GridMotifState(selectedMotif: GridMotifId.flowers);
      final next = gridMotifReducer(
        state,
        const GridMotifsUnlockedAction({GridMotifId.flowers}),
      );
      expect(next.selectedMotif, GridMotifId.flowers);
      expect(next.unlockedMotifs, contains(GridMotifId.flowers));
    });
  });
}
