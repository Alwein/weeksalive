import 'package:weeksalive/core/styles/app_theme_id.dart';

// TODO: Ici ajouter les nouveaux rewards
enum RewardId {
  themeMatcha,
  themePivoine,
  themeTerracotta,
  themeArdoise,
  appLogoAlt,
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

Set<AppThemeId> rewardIdsToThemeIds(Set<RewardId> rewards) {
  return rewards.map((id) => id.asThemeId).whereType<AppThemeId>().toSet();
}

Set<RewardId> themeIdsToRewardIds(Set<AppThemeId> themes) {
  return themes.map(RewardIdThemeMapping.fromThemeId).whereType<RewardId>().toSet();
}
