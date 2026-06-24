import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_renderer.dart';

class WeekGridPainter extends CustomPainter {
  const WeekGridPainter({
    required this.columns,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.dotSpacing,
    required this.activeColor,
    required this.inactiveColor,
    required this.padding,
    this.motif = GridMotifId.dots,
    this.revealProgress = 1.0,
    this.highlightedDots = const [],
    this.highlightColor,
    this.highlightRevealProgress = 1.0,
  });

  final int columns;
  final int totalWeeks;
  final int livedWeeks;
  final double dotSpacing;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final GridMotifId motif;
  final double revealProgress;
  final List<int> highlightedDots;
  final Color? highlightColor;
  final double highlightRevealProgress;

  static double computeHeight({
    required double availableWidth,
    required int totalWeeks,
    required int columns,
    required double dotSpacing,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final paintWidth = availableWidth - padding.left - padding.right;
    final dotSize = (paintWidth - dotSpacing * (columns - 1)) / columns;
    final rows = (totalWeeks / columns).ceil();
    return padding.top + padding.bottom + rows * dotSize + (rows - 1) * dotSpacing;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - padding.left - padding.right - dotSpacing * (columns - 1)) / columns;

    final revealed = revealProgress * totalWeeks;
    final fullyRevealedCount = revealed.floor();
    final currentDotScale = revealed - fullyRevealedCount;

    for (var i = 0; i < totalWeeks; i++) {
      if (i > fullyRevealedCount) break;

      final isLived = i < livedWeeks;
      final color = isLived ? activeColor : inactiveColor;
      final scale = i < fullyRevealedCount ? 1.0 : currentDotScale;

      _drawCell(
        canvas: canvas,
        index: i,
        dotSize: dotSize,
        color: color,
        scale: scale,
        isLived: isLived,
      );
    }

    if (highlightedDots.isNotEmpty && highlightColor != null) {
      final totalHighlighted = highlightedDots.length;
      final continuousVisible = highlightRevealProgress * totalHighlighted;
      final fullyVisible = continuousVisible.floor();
      final partialScale = continuousVisible - fullyVisible;

      for (var hi = 0; hi < totalHighlighted; hi++) {
        if (hi >= fullyVisible + 1) break;
        final dotIndex = highlightedDots[hi];
        if (dotIndex >= totalWeeks || dotIndex >= fullyRevealedCount) continue;

        final scale = hi < fullyVisible ? 1.0 : partialScale;
        if (scale <= 0) continue;

        _drawCell(
          canvas: canvas,
          index: dotIndex,
          dotSize: dotSize,
          color: highlightColor!,
          scale: scale,
          isLived: dotIndex < livedWeeks,
        );
      }
    }
  }

  void _drawCell({
    required Canvas canvas,
    required int index,
    required double dotSize,
    required Color color,
    required double scale,
    required bool isLived,
  }) {
    if (scale <= 0) return;

    final rect = GridMotifRenderer.cellRect(
      padding: padding,
      columns: columns,
      dotSpacing: dotSpacing,
      dotSize: dotSize,
      index: index,
    );

    GridMotifRenderer.draw(
      canvas: canvas,
      motifId: motif,
      variant: gridCellVariantForLifeWeek(isLived: isLived),
      cellIndex: index,
      rect: rect,
      color: color,
      scale: scale,
      isStroke: false,
    );
  }

  @override
  bool shouldRepaint(WeekGridPainter old) =>
      old.revealProgress != revealProgress ||
      old.highlightRevealProgress != highlightRevealProgress ||
      old.livedWeeks != livedWeeks ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.highlightColor != highlightColor ||
      old.highlightedDots != highlightedDots ||
      old.motif != motif;
}
