import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';

enum RewardId {
  themeMatcha,
  themePivoine,
  themeTerracotta,
  themeArdoise,
  appIconDraw,
  appIconOutline,
  appIconSisyphus,
  appIconGold,
  gridMotifFlowers,
  gridMotifDraw,
  gridMotifEmoji,
  gridMotifMoons;

  String get storageKey => name;

  static RewardId? fromStorageKey(String value) {
    if (value == 'gridMotifTreeSprout') return RewardId.gridMotifEmoji;
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

extension RewardIdGridMotifMapping on RewardId {
  GridMotifId? get asGridMotifId => switch (this) {
    RewardId.gridMotifFlowers => GridMotifId.flowers,
    RewardId.gridMotifDraw => GridMotifId.draw,
    RewardId.gridMotifEmoji => GridMotifId.emoji,
    RewardId.gridMotifMoons => GridMotifId.moons,
    _ => null,
  };

  static RewardId? fromGridMotifId(GridMotifId motifId) => switch (motifId) {
    GridMotifId.flowers => RewardId.gridMotifFlowers,
    GridMotifId.draw => RewardId.gridMotifDraw,
    GridMotifId.emoji => RewardId.gridMotifEmoji,
    GridMotifId.moons => RewardId.gridMotifMoons,
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

Set<GridMotifId> rewardIdsToGridMotifIds(Set<RewardId> rewards) {
  return rewards.map((id) => id.asGridMotifId).whereType<GridMotifId>().toSet();
}

Set<RewardId> gridMotifIdsToRewardIds(Set<GridMotifId> motifs) {
  return motifs.map(RewardIdGridMotifMapping.fromGridMotifId).whereType<RewardId>().toSet();
}
