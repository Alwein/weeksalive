import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';

enum RewardId {
  themeMatcha,
  themePivoine,
  themeTerracotta,
  themeArdoise,
  appIconDraw,
  appIconOutline,
  appIconSisyphus,
  appIconGold,
  gridPatternDots;

  String get storageKey => name;

  static RewardId? fromStorageKey(String value) {
    for (final id in values) {
      if (id.storageKey == value) return id;
    }
    return null;
  }
}

extension RewardIdThemeMapping on RewardId {
  AppThemeId? get asThemeId => switch (this) {
    RewardId.themeMatcha => AppThemeId.matcha,
    RewardId.themePivoine => AppThemeId.pivoine,
    RewardId.themeTerracotta => AppThemeId.terracotta,
    RewardId.themeArdoise => AppThemeId.ardoise,
    _ => null,
  };

  static RewardId? fromThemeId(AppThemeId themeId) => switch (themeId) {
    AppThemeId.matcha => RewardId.themeMatcha,
    AppThemeId.pivoine => RewardId.themePivoine,
    AppThemeId.terracotta => RewardId.themeTerracotta,
    AppThemeId.ardoise => RewardId.themeArdoise,
    _ => null,
  };
}

extension RewardIdAppIconMapping on RewardId {
  AppIconId? get asAppIconId => switch (this) {
    RewardId.appIconDraw => AppIconId.draw,
    RewardId.appIconOutline => AppIconId.outline,
    RewardId.appIconSisyphus => AppIconId.sisyphus,
    RewardId.appIconGold => AppIconId.gold,
    _ => null,
  };

  static RewardId? fromAppIconId(AppIconId iconId) => switch (iconId) {
    AppIconId.draw => RewardId.appIconDraw,
    AppIconId.outline => RewardId.appIconOutline,
    AppIconId.sisyphus => RewardId.appIconSisyphus,
    AppIconId.gold => RewardId.appIconGold,
    _ => null,
  };
}

Set<AppThemeId> rewardIdsToThemeIds(Set<RewardId> rewards) {
  return rewards.map((id) => id.asThemeId).whereType<AppThemeId>().toSet();
}

Set<RewardId> themeIdsToRewardIds(Set<AppThemeId> themes) {
  return themes.map(RewardIdThemeMapping.fromThemeId).whereType<RewardId>().toSet();
}

Set<AppIconId> rewardIdsToAppIconIds(Set<RewardId> rewards) {
  return rewards.map((id) => id.asAppIconId).whereType<AppIconId>().toSet();
}

Set<RewardId> appIconIdsToRewardIds(Set<AppIconId> icons) {
  return icons.map(RewardIdAppIconMapping.fromAppIconId).whereType<RewardId>().toSet();
}
