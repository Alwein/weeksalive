import 'package:weeksalive/core/texts/strings.dart';

enum AppIconId {
  defaultIcon,
  light,
  draw,
  silver,
  sisyphus,
  gold;

  static const all = [defaultIcon, light, draw, silver, sisyphus, gold];

  static const alwaysUnlocked = [defaultIcon, light];

  bool get isAlwaysUnlocked => alwaysUnlocked.contains(this);

  String get storageKey => name;

  String? get iosAlternateIconName => switch (this) {
    AppIconId.defaultIcon => null,
    AppIconId.light => 'weeksalive_composer_outline_light',
    AppIconId.draw => 'weeksalive_draw',
    AppIconId.silver => 'weeksalive_composer_outline_silver',
    AppIconId.sisyphus => 'weeksalive_sisyphus',
    AppIconId.gold => 'weeksalive_composer_outline_gold',
  };

  String get androidAlternateIconName => switch (this) {
    AppIconId.defaultIcon => 'composer_outline',
    AppIconId.light => 'composer_outline_light',
    AppIconId.draw => 'draw',
    AppIconId.silver => 'composer_outline_silver',
    AppIconId.sisyphus => 'sisyphus',
    AppIconId.gold => 'composer_outline_gold',
  };

  String get label => switch (this) {
    AppIconId.defaultIcon => Strings.appIconComposer,
    AppIconId.light => Strings.appIconLight,
    AppIconId.draw => Strings.appIconGrid,
    AppIconId.silver => Strings.appIconSilver,
    AppIconId.sisyphus => Strings.appIconSisyphus,
    AppIconId.gold => Strings.appIconGold,
  };

  String get illustrationAsset => switch (this) {
    AppIconId.defaultIcon => 'assets/images/weeksalive_icon_outline.webp',
    AppIconId.light => 'assets/images/weeksalive_icon_outline_light.webp',
    AppIconId.draw => 'assets/images/weeksalive_icon_draw.webp',
    AppIconId.silver => 'assets/images/weeksalive_icon_outline_silver.webp',
    AppIconId.sisyphus => 'assets/images/weeksalive_icon_sisyphus.webp',
    AppIconId.gold => 'assets/images/weeksalive_icon_outline_gold.webp',
  };
}
