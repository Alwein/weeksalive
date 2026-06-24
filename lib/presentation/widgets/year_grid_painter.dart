import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_catalog.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_renderer.dart';

/// Grid of cells for a Gregorian year (journal / illustration).
class YearGridPainter extends CustomPainter {
  const YearGridPainter({
    required this.columns,
    required this.totalDays,
    required this.dotSpacing,
    required this.emptyStrokeColor,
    this.motif = GridMotifId.dots,
    this.fillColor = Colors.black,
    this.pastEmptyColor,
    this.todayEmptyColor,
    this.padding = EdgeInsets.zero,
    this.filledCount = 0,
    this.highlightGridIndex = -1,
    this.fillSizes = const <int>[],
    this.highlightColor,
    this.revealProgress = 1.0,
    this.appearIndex = -1,
    this.appearProgress = 1.0,
  });

  static const _minDotDiameter = 4.0;

  final int columns;
  final int totalDays;
  final double dotSpacing;
  final Color emptyStrokeColor;
  final GridMotifId motif;
  final Color fillColor;
  final Color? pastEmptyColor;
  final Color? todayEmptyColor;
  final EdgeInsets padding;
  final int filledCount;
  final int highlightGridIndex;
  final List<int> fillSizes;
  final Color? highlightColor;
  final double revealProgress;
  final int appearIndex;
  final double appearProgress;

  static double computeHeight({
    required double availableWidth,
    required int totalDays,
    required int columns,
    required double dotSpacing,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final paintWidth = availableWidth - padding.left - padding.right;
    final dotSize = (paintWidth - dotSpacing * (columns - 1)) / columns;
    final rows = (totalDays / columns).ceil();
    return padding.top + padding.bottom + rows * dotSize + (rows - 1) * dotSpacing;
  }

  static int dayIndexAtPosition({
    required Offset localPosition,
    required Size size,
    required int totalDays,
    required int columns,
    required double dotSpacing,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final paintWidth = size.width - padding.left - padding.right;
    final dotSize = (paintWidth - dotSpacing * (columns - 1)) / columns;
    if (dotSize <= 0) return -1;

    final dx = localPosition.dx - padding.left;
    final dy = localPosition.dy - padding.top;
    if (dx < 0 || dy < 0) return -1;

    final cellStride = dotSize + dotSpacing;
    final col = dx ~/ cellStride;
    final row = dy ~/ cellStride;
    if (col < 0 || col >= columns) return -1;

    final index = row * columns + col;
    if (index < 0 || index >= totalDays) return -1;
    return index;
  }

  double _sizeRadius(int level, double maxRadius) {
    const minRadius = _minDotDiameter / 2;
    if (level <= 0) return minRadius;
    if (level >= 4) return maxRadius;
    return minRadius + (maxRadius - minRadius) * (level / 4);
  }

  double _noteScale(int level, double maxRadius) {
    if (GridMotifCatalog.forId(motif).uniformYearNoteSize) return 1.0;
    return _sizeRadius(level, maxRadius) / maxRadius;
  }

  ({double scale, Color color, bool isStroke}) _appearanceForFillSize({
    required int fillSize,
    required Color fillOrHighlightColor,
    required double maxRadius,
  }) {
    return switch (fillSize) {
      -1 => (scale: 1.0, color: emptyStrokeColor, isStroke: true),
      -2 => (
        scale: 1.0,
        color: pastEmptyColor ?? emptyStrokeColor,
        isStroke: pastEmptyColor == null,
      ),
      -3 => (
        scale: 1.0,
        color: todayEmptyColor ?? emptyStrokeColor,
        isStroke: todayEmptyColor == null,
      ),
      _ => (
        scale: _noteScale(fillSize.clamp(0, 4), maxRadius),
        color: fillOrHighlightColor,
        isStroke: false,
      ),
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paintWidth = size.width - padding.left - padding.right;
    final dotSize = (paintWidth - dotSpacing * (columns - 1)) / columns;
    final maxRadius = dotSize / 2;

    final continuousRevealed = revealProgress * filledCount;
    final animationComplete = revealProgress >= 1.0;

    for (var i = 0; i < totalDays; i++) {
      final rect = GridMotifRenderer.cellRect(
        padding: padding,
        columns: columns,
        dotSpacing: dotSpacing,
        dotSize: dotSize,
        index: i,
      );

      if (i >= filledCount) {
        _drawCell(
          canvas: canvas,
          index: i,
          rect: rect,
          fillSize: -1,
          color: emptyStrokeColor,
          scale: 1.0,
          isStroke: true,
        );
        continue;
      }

      final rawLevel = (i < fillSizes.length) ? fillSizes[i] : 4;

      if (i == appearIndex) {
        if (appearProgress <= 0.0) {
          _drawCell(
            canvas: canvas,
            index: i,
            rect: rect,
            fillSize: -1,
            color: emptyStrokeColor,
            scale: 1.0,
            isStroke: true,
          );
          continue;
        }
        final isHighlight = animationComplete && i == highlightGridIndex && highlightColor != null;
        final appearance = _appearanceForFillSize(
          fillSize: rawLevel,
          fillOrHighlightColor: isHighlight ? highlightColor! : fillColor,
          maxRadius: maxRadius,
        );
        _drawCell(
          canvas: canvas,
          index: i,
          rect: rect,
          fillSize: rawLevel,
          color: appearance.color,
          scale: appearance.scale * appearProgress.clamp(0.0, 1.0),
          isStroke: appearance.isStroke,
        );
        continue;
      }

      final revealThreshold = i + 1;
      if (continuousRevealed >= revealThreshold) {
        final isHighlight = animationComplete && i == highlightGridIndex && highlightColor != null;
        final appearance = _appearanceForFillSize(
          fillSize: rawLevel,
          fillOrHighlightColor: isHighlight ? highlightColor! : fillColor,
          maxRadius: maxRadius,
        );
        _drawCell(
          canvas: canvas,
          index: i,
          rect: rect,
          fillSize: rawLevel,
          color: appearance.color,
          scale: appearance.scale,
          isStroke: appearance.isStroke,
        );
      } else if (continuousRevealed > i) {
        final revealScale = (continuousRevealed - i).clamp(0.0, 1.0);
        final appearance = _appearanceForFillSize(
          fillSize: rawLevel,
          fillOrHighlightColor: fillColor,
          maxRadius: maxRadius,
        );
        _drawCell(
          canvas: canvas,
          index: i,
          rect: rect,
          fillSize: rawLevel,
          color: appearance.color,
          scale: appearance.scale * revealScale,
          isStroke: appearance.isStroke,
        );
      } else {
        _drawCell(
          canvas: canvas,
          index: i,
          rect: rect,
          fillSize: -1,
          color: emptyStrokeColor,
          scale: 1.0,
          isStroke: true,
        );
      }
    }
  }

  void _drawCell({
    required Canvas canvas,
    required int index,
    required Rect rect,
    required int fillSize,
    required Color color,
    required double scale,
    required bool isStroke,
  }) {
    if (scale <= 0) return;

    GridMotifRenderer.draw(
      canvas: canvas,
      motifId: motif,
      variant: gridCellVariantForYearFillSize(fillSize),
      cellIndex: index,
      rect: rect,
      color: color,
      scale: scale,
      isStroke: isStroke,
    );
  }

  @override
  bool shouldRepaint(covariant YearGridPainter old) =>
      old.columns != columns ||
      old.totalDays != totalDays ||
      old.dotSpacing != dotSpacing ||
      old.emptyStrokeColor != emptyStrokeColor ||
      old.motif != motif ||
      old.fillColor != fillColor ||
      old.pastEmptyColor != pastEmptyColor ||
      old.todayEmptyColor != todayEmptyColor ||
      old.padding != padding ||
      old.filledCount != filledCount ||
      old.highlightGridIndex != highlightGridIndex ||
      old.revealProgress != revealProgress ||
      old.highlightColor != highlightColor ||
      old.appearIndex != appearIndex ||
      old.appearProgress != appearProgress ||
      old.fillSizes != fillSizes;
}
