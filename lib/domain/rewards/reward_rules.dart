import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/rewards/reward_rule.dart';

abstract final class RewardRules {
  static const List<RewardRule> all = [
    RewardRule(id: RewardId.themeMatcha, condition: StreakMilestoneCondition(30)),
    RewardRule(id: RewardId.themePivoine, condition: StreakMilestoneCondition(120)),
    RewardRule(id: RewardId.themeTerracotta, condition: StreakMilestoneCondition(210)),
    RewardRule(id: RewardId.themeArdoise, condition: StreakMilestoneCondition(300)),
    RewardRule(id: RewardId.appIconDraw, condition: StreakMilestoneCondition(14)),
    RewardRule(id: RewardId.appIconOutline, condition: StreakMilestoneCondition(90)),
    RewardRule(id: RewardId.appIconSisyphus, condition: StreakMilestoneCondition(180)),
    RewardRule(id: RewardId.appIconGold, condition: StreakMilestoneCondition(270)),
    RewardRule(id: RewardId.gridMotifFlowers, condition: StreakMilestoneCondition(7)),
    RewardRule(id: RewardId.gridMotifDraw, condition: StreakMilestoneCondition(60)),
    RewardRule(id: RewardId.gridMotifEmoji, condition: StreakMilestoneCondition(150)),
    RewardRule(id: RewardId.gridMotifMoons, condition: StreakMilestoneCondition(240)),
  ];

  static RewardRule? ruleFor(RewardId id) {
    for (final rule in all) {
      if (rule.id == id) return rule;
    }
    return null;
  }

  static RewardRule? ruleForTheme(AppThemeId themeId) {
    final rewardId = RewardIdThemeMapping.fromThemeId(themeId);
    if (rewardId == null) return null;
    return ruleFor(rewardId);
  }

  static RewardRule? ruleForAppIcon(AppIconId iconId) {
    final rewardId = RewardIdAppIconMapping.fromAppIconId(iconId);
    if (rewardId == null) return null;
    return ruleFor(rewardId);
  }

  static RewardRule? ruleForGridMotif(GridMotifId motifId) {
    final rewardId = RewardIdGridMotifMapping.fromGridMotifId(motifId);
    if (rewardId == null) return null;
    return ruleFor(rewardId);
  }
}
