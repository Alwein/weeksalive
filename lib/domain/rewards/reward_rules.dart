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
    RewardRule(id: RewardId.appIconGold, condition: StreakMilestoneCondition(365)),
    RewardRule(id: RewardId.gridMotifFlowers, condition: StreakMilestoneCondition(2)),
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

  static List<RewardRule> get streakMilestonesSorted {
    final rules = all.where((rule) => rule.condition is StreakMilestoneCondition).toList()
      ..sort((a, b) {
        final aDays = (a.condition as StreakMilestoneCondition).minDays;
        final bDays = (b.condition as StreakMilestoneCondition).minDays;
        final cmp = aDays.compareTo(bDays);
        if (cmp != 0) return cmp;
        return all.indexOf(a).compareTo(all.indexOf(b));
      });
    return rules;
  }

  static List<RewardId> sortByMilestone(Iterable<RewardId> ids) {
    final order = streakMilestonesSorted.map((rule) => rule.id).toList();
    return ids.toList()..sort((a, b) {
      final aIndex = order.indexOf(a);
      final bIndex = order.indexOf(b);
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });
  }

  static ({RewardId rewardId, int daysRemaining})? findNextStreakReward({
    required int currentStreak,
    required Set<RewardId> unlocked,
  }) {
    for (final rule in streakMilestonesSorted) {
      if (unlocked.contains(rule.id)) continue;
      final minDays = (rule.condition as StreakMilestoneCondition).minDays;
      return (
        rewardId: rule.id,
        daysRemaining: (minDays - currentStreak).clamp(0, minDays),
      );
    }
    return null;
  }
}
