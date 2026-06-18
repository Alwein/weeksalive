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
}
