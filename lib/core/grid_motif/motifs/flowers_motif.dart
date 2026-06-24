import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/built_in/built_in_cell_draws.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_context.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_definition.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/svg/flowers/six_petal_solid.dart';
import 'package:weeksalive/core/grid_motif/svg/svg_icon_path.dart';

/// Four-petal flower drawn in a normalized 14×14 design box (center at 7, 7).
///
/// Filled: union of petal circles with an optional central disc (r=2).
/// Life grid cells fill the disc and cycle through three solid styles (4, 4×45°, 6 petals).
/// The six-petal variant uses [FlowerSixPetalSolidPath] (14×14 viewBox).
/// Year cells use 4 petals with the disc cut out as a hole.
/// Outlined: 5 stroked circles — center (r=2) + 4 petals (r=3 at ±3, ±3).
///
/// Performance: unit paths are built once.
/// Each cell replays them via [Canvas] translate + scale only.
abstract final class FlowersMotif {
  static const _designSpan = SvgIconPath.designSpan;
  static const _petalOffset = 3.0;
  static const _filledPetalRadius = 4.0;
  static const _filledHoleRadius = 2.0;
  static const _outlinedCenterRadius = 2.0;
  static const _outlinedPetalRadius = 3.0;
  static const _outlinedStroke = 1.0;

  static const _petalSigns = <Offset>[
    Offset(-1, -1),
    Offset(1, -1),
    Offset(-1, 1),
    Offset(1, 1),
  ];

  static final _filled = [filledFlower];
  static final _filledSolid = [
    filledFlowerSolid,
    filledFlowerSolidRotated,
    filledFlowerSixPetalSolid,
  ];
  static final _outlined = [outlinedFlower];

  static final definition = GridMotifDefinition(
    id: GridMotifId.flowers,
    representations: {
      GridCellVariant.lifeLived: _filledSolid,
      GridCellVariant.lifeRemaining: _filledSolid,
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
  static Path? _unitFilledSolidPath;
  static Path? _unitFilledSixPetalSolidPath;

  static Path get _unitFilledPathOrBuild =>
      _unitFilledPath ??= _buildFilledPath(petalCenters: _fourPetalCenters(), withCenterHole: true);

  static Path get _unitFilledSolidPathOrBuild =>
      _unitFilledSolidPath ??= _buildFilledPath(petalCenters: _fourPetalCenters(), withCenterHole: false);

  static Path get _unitFilledSixPetalSolidPathOrBuild => _unitFilledSixPetalSolidPath ??= SvgIconPath.toDesignPath(
    pathData: FlowerSixPetalSolidPath.pathData,
    viewBoxSize: FlowerSixPetalSolidPath.viewBoxSize,
  );

  static void filledFlower(Canvas canvas, GridCellContext context) {
    _drawFilledFlower(canvas, context, _unitFilledPathOrBuild);
  }

  static void filledFlowerSolid(Canvas canvas, GridCellContext context) {
    _drawFilledFlower(canvas, context, _unitFilledSolidPathOrBuild);
  }

  static void filledFlowerSolidRotated(Canvas canvas, GridCellContext context) {
    _drawFilledFlower(canvas, context, _unitFilledSolidPathOrBuild, rotation: math.pi / 4);
  }

  static void filledFlowerSixPetalSolid(Canvas canvas, GridCellContext context) {
    _drawFilledFlower(canvas, context, _unitFilledSixPetalSolidPathOrBuild);
  }

  static void _drawFilledFlower(
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

  static void outlinedFlower(Canvas canvas, GridCellContext context) {
    final unit = _unit(context);
    if (unit <= 0) return;

    final center = context.rect.center;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(unit);

    final strokeWidth = math.max(BuiltInCellDraws.emptyStrokeWidth / unit, _outlinedStroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = context.color;

    canvas.drawCircle(Offset.zero, _outlinedCenterRadius, paint);
    for (final sign in _petalSigns) {
      canvas.drawCircle(
        Offset(sign.dx * _petalOffset, sign.dy * _petalOffset),
        _outlinedPetalRadius,
        paint,
      );
    }
    canvas.restore();
  }

  static Path _buildFilledPath({
    required List<Offset> petalCenters,
    required bool withCenterHole,
    double petalRadius = _filledPetalRadius,
  }) {
    Path? petals;
    for (final petalCenter in petalCenters) {
      final circle = Path()..addOval(Rect.fromCircle(center: petalCenter, radius: petalRadius));
      petals = petals == null ? circle : Path.combine(PathOperation.union, petals, circle);
    }

    if (!withCenterHole) {
      final center = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: _filledHoleRadius));
      return Path.combine(PathOperation.union, petals!, center);
    }

    final hole = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: _filledHoleRadius));
    return Path.combine(PathOperation.difference, petals!, hole);
  }

  static List<Offset> _fourPetalCenters() {
    return _petalSigns.map((sign) => Offset(sign.dx * _petalOffset, sign.dy * _petalOffset)).toList(growable: false);
  }

  static double _unit(GridCellContext context) {
    return context.rect.shortestSide / _designSpan * context.scale;
  }
}
