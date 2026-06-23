import 'package:weeksalive/core/texts/strings.dart';

enum AppIconId {
  composer,
  dark,
  draw,
  outline,
  sisyphus,
  gold;

  static const all = [composer, dark, draw, outline, sisyphus, gold];

  static const alwaysUnlocked = [composer, dark];

  bool get isAlwaysUnlocked => alwaysUnlocked.contains(this);

  String get storageKey => name;

  String? get iosAlternateIconName => switch (this) {
    AppIconId.composer => null,
    AppIconId.dark => 'weeksalive_dark',
    AppIconId.draw => 'weeksalive_draw',
    AppIconId.outline => 'weeksalive_outline',
    AppIconId.sisyphus => 'weeksalive_sisyphus',
    AppIconId.gold => 'weeksalive_gold',
  };

  String get androidAlternateIconName => switch (this) {
    AppIconId.composer => 'composer',
    AppIconId.dark => 'dark',
    AppIconId.draw => 'draw',
    AppIconId.outline => 'outline',
    AppIconId.sisyphus => 'sisyphus',
    AppIconId.gold => 'gold',
  };

  String get label => switch (this) {
    AppIconId.composer => Strings.appIconComposer,
    AppIconId.dark => Strings.appIconDark,
    AppIconId.draw => Strings.appIconDraw,
    AppIconId.outline => Strings.appIconOutline,
    AppIconId.sisyphus => Strings.appIconSisyphus,
    AppIconId.gold => Strings.appIconGold,
  };

  String get illustrationAsset => switch (this) {
    AppIconId.composer => 'assets/images/weeksalive_icon_1x.webp',
    AppIconId.dark => 'assets/images/weeksalive_icon_dark_1x.webp',
    AppIconId.draw => 'assets/images/weeksalive_icon_draw_1x.webp',
    AppIconId.outline => 'assets/images/weeksalive_icon_outline_1x.webp',
    AppIconId.sisyphus => 'assets/images/weeksalive_icon_sisyphus_1x.webp',
    AppIconId.gold => 'assets/images/weeksalive_icon_gold_1x.webp',
  };
}
