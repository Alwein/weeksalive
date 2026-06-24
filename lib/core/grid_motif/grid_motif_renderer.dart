import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/built_in/dots_motif.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_context.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_catalog.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';

abstract final class GridMotifRenderer {
  static void draw({
    required Canvas canvas,
    required GridMotifId motifId,
    required GridCellVariant variant,
    required int cellIndex,
    required Rect rect,
    required Color color,
    required double scale,
    required bool isStroke,
  }) {
    final definition = GridMotifCatalog.forId(motifId);
    final draw = definition.resolveDraw(
      variant: variant,
      cellIndex: cellIndex,
      dotsFallback: DotsMotif.drawFor(variant: variant, cellIndex: cellIndex),
    );
    draw(
      canvas,
      GridCellContext(
        rect: rect,
        color: color,
        scale: scale,
        cellIndex: cellIndex,
        isStroke: isStroke,
      ),
    );
  }

  static Rect cellRect({
    required EdgeInsets padding,
    required int columns,
    required double dotSpacing,
    required double dotSize,
    required int index,
  }) {
    final maxRadius = dotSize / 2;
    final col = index % columns;
    final row = index ~/ columns;
    final center = Offset(
      padding.left + col * (dotSize + dotSpacing) + maxRadius,
      padding.top + row * (dotSize + dotSpacing) + maxRadius,
    );
    return Rect.fromCenter(center: center, width: dotSize, height: dotSize);
  }
}
