import 'package:flutter/material.dart';

class WeekGridPainter extends CustomPainter {
  const WeekGridPainter({
    required this.columns,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.dotSpacing,
    required this.activeColor,
    required this.inactiveColor,
    required this.padding,
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
  final double revealProgress;

  /// Indices (within the full grid) of dots to highlight.
  final List<int> highlightedDots;

  /// Color used for highlighted dots.
  final Color? highlightColor;

  /// Progress from 0.0 to 1.0 controlling how many highlighted dots are visible.
  /// At 0.0 none are shown; at 1.0 all are shown, appearing one by one.
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
    final maxRadius = dotSize / 2;

    // revealProgress goes from 0 to 1 over totalWeeks dots.
    // revealed is the continuous count of dots that should be visible.
    final revealed = revealProgress * totalWeeks;
    final fullyRevealedCount = revealed.floor();
    // fractional part drives the scale of the currently-appearing dot
    final currentDotScale = revealed - fullyRevealedCount;

    final activePaint = Paint()..color = activeColor;
    final inactivePaint = Paint()..color = inactiveColor;

    for (var i = 0; i < totalWeeks; i++) {
      if (i > fullyRevealedCount) break;

      final col = i % columns;
      final row = i ~/ columns;
      final x = padding.left + col * (dotSize + dotSpacing) + maxRadius;
      final y = padding.top + row * (dotSize + dotSpacing) + maxRadius;
      final paint = i < livedWeeks ? activePaint : inactivePaint;

      if (i < fullyRevealedCount) {
        canvas.drawCircle(Offset(x, y), maxRadius, paint);
      } else {
        // This is the dot currently appearing — scale its radius from 0 to full
        final radius = maxRadius * currentDotScale;
        if (radius > 0) canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    // Draw highlighted dots on top, appearing one by one.
    if (highlightedDots.isNotEmpty && highlightColor != null) {
      final totalHighlighted = highlightedDots.length;
      final continuousVisible = highlightRevealProgress * totalHighlighted;
      final fullyVisible = continuousVisible.floor();
      final partialScale = continuousVisible - fullyVisible;

      for (var hi = 0; hi < totalHighlighted; hi++) {
        if (hi >= fullyVisible + 1) break;
        final dotIndex = highlightedDots[hi];
        if (dotIndex >= totalWeeks) continue;

        // Skip dots that haven't been revealed by revealProgress yet.
        if (dotIndex >= fullyRevealedCount) continue;

        final col = dotIndex % columns;
        final row = dotIndex ~/ columns;
        final x = padding.left + col * (dotSize + dotSpacing) + maxRadius;
        final y = padding.top + row * (dotSize + dotSpacing) + maxRadius;

        final double radius;
        if (hi < fullyVisible) {
          radius = maxRadius;
        } else {
          radius = maxRadius * partialScale;
        }

        if (radius > 0) {
          canvas.drawCircle(
            Offset(x, y),
            radius,
            Paint()..color = highlightColor!,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(WeekGridPainter old) =>
      old.revealProgress != revealProgress ||
      old.highlightRevealProgress != highlightRevealProgress ||
      old.livedWeeks != livedWeeks ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.highlightColor != highlightColor ||
      old.highlightedDots != highlightedDots;
}
