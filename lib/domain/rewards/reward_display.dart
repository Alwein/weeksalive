import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';

extension RewardIdDisplay on RewardId {
  String get label => switch (this) {
    RewardId.themeMatcha => Strings.themeMatcha,
    RewardId.themePivoine => Strings.themePivoine,
    RewardId.themeTerracotta => Strings.themeTerracotta,
    RewardId.themeArdoise => Strings.themeArdoise,
    RewardId.appIconDraw => Strings.appIconGrid,
    RewardId.appIconOutline => Strings.appIconSilver,
    RewardId.appIconSisyphus => Strings.appIconSisyphus,
    RewardId.appIconGold => Strings.appIconGold,
    RewardId.gridMotifFlowers => Strings.gridMotifFlowers,
    RewardId.gridMotifDraw => Strings.gridMotifDraw,
    RewardId.gridMotifEmoji => Strings.gridMotifEmoji,
    RewardId.gridMotifMoons => Strings.gridMotifMoons,
  };

  String get category => switch (this) {
    RewardId.themeMatcha ||
    RewardId.themePivoine ||
    RewardId.themeTerracotta ||
    RewardId.themeArdoise =>
      Strings.streaksCategoryTheme,
    RewardId.appIconDraw ||
    RewardId.appIconOutline ||
    RewardId.appIconSisyphus ||
    RewardId.appIconGold =>
      Strings.streaksCategoryAppIcon,
    RewardId.gridMotifFlowers ||
    RewardId.gridMotifDraw ||
    RewardId.gridMotifEmoji ||
    RewardId.gridMotifMoons =>
      Strings.streaksCategoryGridMotif,
  };

  String get description => '$category - $label';

  AppThemeId? get previewThemeId => asThemeId;

  AppIconId? get previewAppIconId => asAppIconId;

  GridMotifId? get previewGridMotifId => asGridMotifId;
}
