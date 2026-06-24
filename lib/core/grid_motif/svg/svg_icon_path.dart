import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Converts an SVG path from its viewBox into the grid motif design space
/// (14×14 box centered at the origin).
abstract final class SvgIconPath {
  static const designSpan = 14.0;

  static Path toDesignPath({
    required String pathData,
    required double viewBoxSize,
  }) {
    final center = viewBoxSize / 2;
    final scale = designSpan / viewBoxSize;
    final matrix = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(-center * scale, -center * scale, 0);

    return parseSvgPathData(pathData).transform(matrix.storage);
  }
}
