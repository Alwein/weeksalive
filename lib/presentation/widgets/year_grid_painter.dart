import 'package:flutter/material.dart';

/// Grid of circular dots for a Gregorian year (journal / illustration).
class YearGridPainter extends CustomPainter {
  const YearGridPainter({
    required this.columns,
    required this.totalDays,
    required this.dotSpacing,
    required this.emptyStrokeColor,
    this.fillColor = Colors.black,
    this.pastEmptyColor,
    this.padding = EdgeInsets.zero,
    this.filledCount = 0,
    this.highlightGridIndex = -1,
    this.fillSizes = const <int>[],
    this.highlightColor,
    this.revealProgress = 1.0,
    this.appearIndex = -1,
    this.appearProgress = 1.0,
  });

  static const _emptyStrokeWidth = 1.0;

  /// Minimum dot diameter (pixels) for size level 0.
  static const _minDotDiameter = 4.0;

  final int columns;
  final int totalDays;
  final double dotSpacing;
  final Color emptyStrokeColor;

  /// Uniform color used for all filled dots.
  final Color fillColor;

  /// Color used to fill past days that have no journal entry.
  /// When null, those dots are drawn as empty circles.
  final Color? pastEmptyColor;
  final EdgeInsets padding;

  /// When > 0, draws filled circles with optional [revealProgress] animation (onboarding).
  final int filledCount;
  final int highlightGridIndex;

  /// Per-dot size level in [0, 4]. 0 → 2 px diameter, 4 → full cell diameter.
  final List<int> fillSizes;
  final Color? highlightColor;
  final double revealProgress;

  /// Index of a single dot that should scale in (from 0) on save. -1 disables.
  final int appearIndex;

  /// Scale-in progress in [0, 1] applied to the [appearIndex] dot.
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

  /// Maps a size level [0, 4] to a radius given the maximum cell radius.
  double _sizeRadius(int level, double maxRadius) {
    const minRadius = _minDotDiameter / 2;
    if (level <= 0) return minRadius;
    if (level >= 4) return maxRadius;
    return minRadius + (maxRadius - minRadius) * (level / 4);
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

      final rawLevel = (i < fillSizes.length) ? fillSizes[i] : 4;
      if (rawLevel == -1) {
        canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
        continue;
      }
      if (rawLevel == -2) {
        if (pastEmptyColor != null) {
          canvas.drawCircle(center, maxRadius, Paint()..color = pastEmptyColor!);
        } else {
          canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
        }
        continue;
      }

      final isHighlight = animationComplete && i == highlightGridIndex && highlightColor != null;
      final color = isHighlight ? highlightColor! : fillColor;
      final level = rawLevel.clamp(0, 4);
      var targetRadius = _sizeRadius(level, maxRadius);

      if (i == appearIndex) {
        // Scale this single dot in on save: empty circle at 0, full size at 1.
        if (appearProgress <= 0.0) {
          canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
          continue;
        }
        targetRadius *= appearProgress.clamp(0.0, 1.0);
        canvas.drawCircle(center, targetRadius, Paint()..color = color);
        continue;
      }

      final revealThreshold = i + 1;
      if (continuousRevealed >= revealThreshold) {
        canvas.drawCircle(center, targetRadius, Paint()..color = color);
      } else if (continuousRevealed > i) {
        final scale = continuousRevealed - i;
        final radius = targetRadius * scale.clamp(0.0, 1.0);
        if (radius > 0) {
          canvas.drawCircle(center, radius, Paint()..color = color);
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
      old.fillColor != fillColor ||
      old.pastEmptyColor != pastEmptyColor ||
      old.padding != padding ||
      old.filledCount != filledCount ||
      old.highlightGridIndex != highlightGridIndex ||
      old.revealProgress != revealProgress ||
      old.highlightColor != highlightColor ||
      old.appearIndex != appearIndex ||
      old.appearProgress != appearProgress ||
      old.fillSizes != fillSizes;
}
