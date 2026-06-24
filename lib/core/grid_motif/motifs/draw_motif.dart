import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_context.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_definition.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/svg/draw/cell_draw.dart';
import 'package:weeksalive/core/grid_motif/svg/svg_icon_path.dart';

abstract final class DrawMotif {
  static const _designSpan = SvgIconPath.designSpan;
  static const _rotationPlus15 = 30 * math.pi / 180;
  static const _rotationMinus15 = -30 * math.pi / 180;

  static final _filled = [
    filledDraw,
    filledDrawRotatedPlus15,
    filledDrawRotatedMinus15,
  ];
  static final _outlined = [
    outlinedDraw,
    outlinedDrawRotatedPlus15,
    outlinedDrawRotatedMinus15,
  ];

  static final definition = GridMotifDefinition(
    id: GridMotifId.draw,
    representations: {
      GridCellVariant.yearNote1: _filled,
      GridCellVariant.yearNote2: _filled,
      GridCellVariant.yearNote3: _filled,
      GridCellVariant.yearNote4: _filled,
      GridCellVariant.yearNote5: _filled,
      GridCellVariant.yearEmptyPast: _filled,
      GridCellVariant.yearTodayEmpty: _filled,
      GridCellVariant.yearFuture: _outlined,
    },
  );

  static Path? _unitFilledPath;
  static Path? _unitOutlinedPath;

  static Path get _unitFilledPathOrBuild => _unitFilledPath ??= SvgIconPath.toDesignPath(
    pathData: CellDrawPath.pathData,
    viewBoxSize: CellDrawPath.viewBoxSize,
  );

  static Path get _unitOutlinedPathOrBuild => _unitOutlinedPath ??= SvgIconPath.toDesignPath(
    pathData: CellDrawnOutlinePath.pathData,
    viewBoxSize: CellDrawnOutlinePath.viewBoxSize,
  );

  static void filledDraw(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitFilledPathOrBuild);
  }

  static void filledDrawRotatedPlus15(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitFilledPathOrBuild, rotation: _rotationPlus15);
  }

  static void filledDrawRotatedMinus15(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitFilledPathOrBuild, rotation: _rotationMinus15);
  }

  static void outlinedDraw(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitOutlinedPathOrBuild);
  }

  static void outlinedDrawRotatedPlus15(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitOutlinedPathOrBuild, rotation: _rotationPlus15);
  }

  static void outlinedDrawRotatedMinus15(Canvas canvas, GridCellContext context) {
    _drawFilledPath(canvas, context, _unitOutlinedPathOrBuild, rotation: _rotationMinus15);
  }

  static void _drawFilledPath(
    Canvas canvas,
    GridCellContext context,
    Path path, {
    double rotation = 0,
  }) {
    final unit = _unit(context);
    if (unit <= 0) return;

    final center = context.rect.center;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (rotation != 0) canvas.rotate(rotation);
    canvas.scale(unit);
    canvas.drawPath(path, Paint()..color = context.color);
    canvas.restore();
  }

  static double _unit(GridCellContext context) {
    return context.rect.shortestSide / _designSpan * context.scale;
  }
}
