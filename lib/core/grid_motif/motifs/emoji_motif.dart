import 'package:flutter/material.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_context.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_definition.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/svg/emoji/cell_emoji.dart';
import 'package:weeksalive/core/grid_motif/svg/svg_icon_path.dart';

/// Emoji shapes drawn in a normalized 14×14 design box (center at origin).
///
/// Each note level maps to its own emoji path ([CellEmojiNote1Path] … [CellEmojiNote5Path]).
/// Size is uniform across note levels — differentiation is visual, not scalar.
///
/// Performance: unit paths are built once per emoji.
abstract final class EmojiMotif {
  static const _designSpan = SvgIconPath.designSpan;

  static const definition = GridMotifDefinition(
    id: GridMotifId.emoji,
    uniformYearNoteSize: true,
    representations: {
      GridCellVariant.yearNote1: [emojiNote1Draw],
      GridCellVariant.yearNote2: [emojiNote2Draw],
      GridCellVariant.yearNote3: [emojiNote3Draw],
      GridCellVariant.yearNote4: [emojiNote4Draw],
      GridCellVariant.yearNote5: [emojiNote5Draw],
    },
  );

  static final _unitPaths = List<Path?>.filled(5, null);

  static Path? _unitPathOrBuild({
    required int noteLevel,
    required String pathData,
    required double viewBoxSize,
  }) {
    if (pathData.startsWith('TODO')) return null;

    return _unitPaths[noteLevel] ??= SvgIconPath.toDesignPath(
      pathData: pathData,
      viewBoxSize: viewBoxSize,
    );
  }

  static void emojiNote1Draw(Canvas canvas, GridCellContext context) {
    _drawEmoji(
      canvas,
      context,
      noteLevel: 0,
      pathData: CellEmojiNote1Path.pathData,
      viewBoxSize: CellEmojiNote1Path.viewBoxSize,
    );
  }

  static void emojiNote2Draw(Canvas canvas, GridCellContext context) {
    _drawEmoji(
      canvas,
      context,
      noteLevel: 1,
      pathData: CellEmojiNote2Path.pathData,
      viewBoxSize: CellEmojiNote2Path.viewBoxSize,
    );
  }

  static void emojiNote3Draw(Canvas canvas, GridCellContext context) {
    _drawEmoji(
      canvas,
      context,
      noteLevel: 2,
      pathData: CellEmojiNote3Path.pathData,
      viewBoxSize: CellEmojiNote3Path.viewBoxSize,
    );
  }

  static void emojiNote4Draw(Canvas canvas, GridCellContext context) {
    _drawEmoji(
      canvas,
      context,
      noteLevel: 3,
      pathData: CellEmojiNote4Path.pathData,
      viewBoxSize: CellEmojiNote4Path.viewBoxSize,
    );
  }

  static void emojiNote5Draw(Canvas canvas, GridCellContext context) {
    _drawEmoji(
      canvas,
      context,
      noteLevel: 4,
      pathData: CellEmojiNote5Path.pathData,
      viewBoxSize: CellEmojiNote5Path.viewBoxSize,
    );
  }

  static void _drawEmoji(
    Canvas canvas,
    GridCellContext context, {
    required int noteLevel,
    required String pathData,
    required double viewBoxSize,
  }) {
    final path = _unitPathOrBuild(noteLevel: noteLevel, pathData: pathData, viewBoxSize: viewBoxSize);
    if (path == null) return;

    final unit = _unit(context);
    if (unit <= 0) return;

    final center = context.rect.center;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(unit);
    canvas.drawPath(path, Paint()..color = context.color);
    canvas.restore();
  }

  static double _unit(GridCellContext context) {
    return context.rect.shortestSide / _designSpan * context.scale;
  }
}
