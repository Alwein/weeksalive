import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/grid_motif/built_in/built_in_cell_draws.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/motifs/flowers_motif.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_catalog.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

void main() {
  group('GridMotifCatalog', () {
    test('resolves every motif id', () {
      for (final id in GridMotifId.all) {
        expect(GridMotifCatalog.forId(id).id, id);
      }
    });

    test('dots motif provides a draw function for every variant', () {
      for (final variant in GridCellVariant.values) {
        final draw = GridMotifCatalog.dots.resolveDraw(
          variant: variant,
          cellIndex: 0,
          dotsFallback: BuiltInCellDraws.filledCircle,
        );
        expect(draw, isNotNull);
      }
    });

    test('flowers motif provides its own draw functions', () {
      const lifeDraws = {
        FlowersMotif.filledFlowerSolid,
        FlowersMotif.filledFlowerSolidRotated,
        FlowersMotif.filledFlowerSixPetalSolid,
      };

      for (var cellIndex = 0; cellIndex < 12; cellIndex++) {
        final lifeDraw = GridMotifCatalog.flowers.resolveDraw(
          variant: GridCellVariant.lifeLived,
          cellIndex: cellIndex,
          dotsFallback: BuiltInCellDraws.filledCircle,
        );
        expect(lifeDraws, contains(lifeDraw));
      }

      final yearDraw = GridMotifCatalog.flowers.resolveDraw(
        variant: GridCellVariant.yearNote1,
        cellIndex: 3,
        dotsFallback: BuiltInCellDraws.filledCircle,
      );
      expect(yearDraw, FlowersMotif.filledFlower);
    });
  });
}
