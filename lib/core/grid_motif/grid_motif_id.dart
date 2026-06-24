import 'package:weeksalive/core/texts/strings.dart';

enum GridMotifId {
  dots,
  squares,
  flowers,
  draw,
  treeSprout,
  moons;

  static const all = [dots, squares, flowers, draw, treeSprout, moons];

  static const alwaysUnlocked = [dots, squares];

  bool get isAlwaysUnlocked => alwaysUnlocked.contains(this);

  String get storageKey => name;

  String get label => switch (this) {
    GridMotifId.dots => Strings.gridMotifDots,
    GridMotifId.squares => Strings.gridMotifSquares,
    GridMotifId.flowers => Strings.gridMotifFlowers,
    GridMotifId.draw => Strings.gridMotifDraw,
    GridMotifId.treeSprout => Strings.gridMotifTreeSprout,
    GridMotifId.moons => Strings.gridMotifMoons,
  };

  static GridMotifId? fromStorageKey(String value) {
    for (final id in values) {
      if (id.storageKey == value) return id;
    }
    return null;
  }
}
