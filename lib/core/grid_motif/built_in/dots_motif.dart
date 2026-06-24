import 'package:weeksalive/core/grid_motif/built_in/built_in_cell_draws.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_draw.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_definition.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

abstract final class DotsMotif {
  static final _filled = [BuiltInCellDraws.filledCircle];
  static final _stroke = [BuiltInCellDraws.strokeCircle];

  static final definition = GridMotifDefinition(
    id: GridMotifId.dots,
    representations: {
      GridCellVariant.lifeLived: _filled,
      GridCellVariant.lifeRemaining: _filled,
      GridCellVariant.yearNote1: _filled,
      GridCellVariant.yearNote2: _filled,
      GridCellVariant.yearNote3: _filled,
      GridCellVariant.yearNote4: _filled,
      GridCellVariant.yearNote5: _filled,
      GridCellVariant.yearEmptyPast: _filled,
      GridCellVariant.yearTodayEmpty: _filled,
      GridCellVariant.yearFuture: _stroke,
    },
  );

  static GridCellDraw drawFor({
    required GridCellVariant variant,
    required int cellIndex,
  }) {
    return definition.resolveDraw(
      variant: variant,
      cellIndex: cellIndex,
      dotsFallback: BuiltInCellDraws.filledCircle,
    );
  }
}
