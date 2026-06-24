import 'package:weeksalive/core/grid_motif/grid_cell_draw.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

class GridMotifDefinition {
  const GridMotifDefinition({
    required this.id,
    required this.representations,
    this.fallback,
    this.uniformYearNoteSize = false,
  });

  final GridMotifId id;
  final Map<GridCellVariant, List<GridCellDraw>> representations;
  final GridCellDraw? fallback;

  /// When true, year note cells (levels 1–5) are drawn at full size.
  /// Differentiation comes from the motif shape, not [GridCellContext.scale].
  final bool uniformYearNoteSize;

  GridCellDraw resolveDraw({
    required GridCellVariant variant,
    required int cellIndex,
    required GridCellDraw dotsFallback,
  }) {
    final reps = representations[variant];
    if (reps == null || reps.isEmpty) {
      return fallback ?? dotsFallback;
    }
    if (reps.length == 1) return reps.first;
    final index = Object.hash(id, variant, cellIndex).abs() % reps.length;
    return reps[index];
  }
}
