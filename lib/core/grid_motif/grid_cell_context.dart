import 'package:flutter/material.dart';

class GridCellContext {
  const GridCellContext({
    required this.rect,
    required this.color,
    required this.scale,
    required this.cellIndex,
    required this.isStroke,
  });

  final Rect rect;
  final Color color;
  final double scale;
  final int cellIndex;
  final bool isStroke;
}
