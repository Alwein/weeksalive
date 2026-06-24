import 'package:weeksalive/core/grid_motif/built_in/dots_motif.dart';
import 'package:weeksalive/core/grid_motif/built_in/squares_motif.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_definition.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/motifs/draw_motif.dart';
import 'package:weeksalive/core/grid_motif/motifs/emoji_motif.dart';
import 'package:weeksalive/core/grid_motif/motifs/flowers_motif.dart';
import 'package:weeksalive/core/grid_motif/motifs/moons_motif.dart';

abstract final class GridMotifCatalog {
  static final dots = DotsMotif.definition;
  static final squares = SquaresMotif.definition;
  static final flowers = FlowersMotif.definition;
  static final draw = DrawMotif.definition;
  static const emoji = EmojiMotif.definition;
  static const moons = MoonsMotif.definition;

  static GridMotifDefinition forId(GridMotifId id) => switch (id) {
    GridMotifId.dots => dots,
    GridMotifId.squares => squares,
    GridMotifId.flowers => flowers,
    GridMotifId.draw => draw,
    GridMotifId.emoji => emoji,
    GridMotifId.moons => moons,
  };
}
