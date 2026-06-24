import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_context.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_draw.dart';

abstract final class BuiltInCellDraws {
  static const emptyStrokeWidth = 1.0;

  static void filledCircle(Canvas canvas, GridCellContext context) {
    final radius = _scaledRadius(context);
    if (radius <= 0) return;
    canvas.drawCircle(context.rect.center, radius, Paint()..color = context.color);
  }

  static void strokeCircle(Canvas canvas, GridCellContext context) {
    final maxRadius = context.rect.shortestSide / 2;
    final strokeRadius = maxRadius - emptyStrokeWidth / 2;
    if (strokeRadius <= 0) return;
    canvas.drawCircle(
      context.rect.center,
      strokeRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = emptyStrokeWidth
        ..color = context.color,
    );
  }

  static void filledSquare(Canvas canvas, GridCellContext context) {
    final side = context.rect.shortestSide * context.scale;
    if (side <= 0) return;
    final square = Rect.fromCenter(center: context.rect.center, width: side, height: side);
    canvas.drawRect(square, Paint()..color = context.color);
  }

  static void strokeSquare(Canvas canvas, GridCellContext context) {
    final maxSide = context.rect.shortestSide;
    final side = maxSide - emptyStrokeWidth;
    if (side <= 0) return;
    final square = Rect.fromCenter(center: context.rect.center, width: side, height: side);
    canvas.drawRect(
      square,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = emptyStrokeWidth
        ..color = context.color,
    );
  }

  static GridCellDraw filledCircleDraw = filledCircle;
  static GridCellDraw strokeCircleDraw = strokeCircle;
  static GridCellDraw filledSquareDraw = filledSquare;
  static GridCellDraw strokeSquareDraw = strokeSquare;

  static double _scaledRadius(GridCellContext context) {
    return context.rect.shortestSide / 2 * context.scale;
  }
}
