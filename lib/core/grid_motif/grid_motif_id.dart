import 'package:weeksalive/core/texts/strings.dart';

enum GridMotifId {
  dots,
  squares,
  flowers,
  draw,
  emoji,
  moons;

  static const all = [dots, squares, flowers, draw, emoji, moons];

  static const alwaysUnlocked = [dots, squares];

  bool get isAlwaysUnlocked => alwaysUnlocked.contains(this);

  String get storageKey => name;

  String get label => switch (this) {
    GridMotifId.dots => Strings.gridMotifDots,
    GridMotifId.squares => Strings.gridMotifSquares,
    GridMotifId.flowers => Strings.gridMotifFlowers,
    GridMotifId.draw => Strings.gridMotifDraw,
    GridMotifId.emoji => Strings.gridMotifEmoji,
    GridMotifId.moons => Strings.gridMotifMoons,
  };

  static GridMotifId? fromStorageKey(String value) {
    if (value == 'treeSprout') return GridMotifId.emoji;
    for (final id in values) {
      if (id.storageKey == value) return id;
    }
    return null;
  }
}
