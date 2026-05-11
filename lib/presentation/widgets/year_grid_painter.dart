import 'package:flutter/material.dart';

/// Grid of circular dots for a Gregorian year (journal / illustration).
class YearGridPainter extends CustomPainter {
  const YearGridPainter({
    required this.columns,
    required this.totalDays,
    required this.dotSpacing,
    required this.emptyStrokeColor,
    this.padding = EdgeInsets.zero,
    this.filledCount = 0,
    this.highlightGridIndex = -1,
    this.fillColors = const <Color>[],
    this.highlightColor,
    this.revealProgress = 1.0,
  });

  static const _emptyStrokeWidth = 1.0;

  final int columns;
  final int totalDays;
  final double dotSpacing;
  final Color emptyStrokeColor;
  final EdgeInsets padding;

  /// When > 0, draws filled circles with optional [revealProgress] animation (onboarding).
  final int filledCount;
  final int highlightGridIndex;
  final List<Color> fillColors;
  final Color? highlightColor;
  final double revealProgress;

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

  @override
  void paint(Canvas canvas, Size size) {
    final paintWidth = size.width - padding.left - padding.right;
    final dotSize = (paintWidth - dotSpacing * (columns - 1)) / columns;
    final maxRadius = dotSize / 2;
    final emptyStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _emptyStrokeWidth
      ..color = emptyStrokeColor;

    final emptyStrokeRadius = maxRadius - _emptyStrokeWidth / 2;

    final continuousRevealed = revealProgress * filledCount;
    final animationComplete = revealProgress >= 1.0;

    for (var i = 0; i < totalDays; i++) {
      final col = i % columns;
      final row = i ~/ columns;
      final cx = padding.left + col * (dotSize + dotSpacing) + maxRadius;
      final cy = padding.top + row * (dotSize + dotSpacing) + maxRadius;
      final center = Offset(cx, cy);

      if (i >= filledCount) {
        canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
        continue;
      }

      final revealThreshold = i + 1;
      final fillColor = animationComplete && i == highlightGridIndex && highlightColor != null
          ? highlightColor!
          : fillColors[i];

      if (continuousRevealed >= revealThreshold) {
        canvas.drawCircle(center, maxRadius, Paint()..color = fillColor);
      } else if (continuousRevealed > i) {
        final scale = continuousRevealed - i;
        final radius = maxRadius * scale.clamp(0.0, 1.0);
        if (radius > 0) {
          canvas.drawCircle(center, radius, Paint()..color = fillColor);
        }
      } else {
        canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant YearGridPainter old) =>
      old.columns != columns ||
      old.totalDays != totalDays ||
      old.dotSpacing != dotSpacing ||
      old.emptyStrokeColor != emptyStrokeColor ||
      old.padding != padding ||
      old.filledCount != filledCount ||
      old.highlightGridIndex != highlightGridIndex ||
      old.revealProgress != revealProgress ||
      old.highlightColor != highlightColor ||
      old.fillColors != fillColors;
}
