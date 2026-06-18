import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/rewards/reward_rule.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';

class RewardUnlockService {
  const RewardUnlockService({
    this.rules = RewardRules.all,
  });

  final List<RewardRule> rules;

  Set<RewardId> evaluateEligible({
    required int bestStreak,
    required int totalDaysLogged,
  }) {
    final eligible = <RewardId>{};

    for (final rule in rules) {
      if (_isConditionMet(
        rule.condition,
        bestStreak: bestStreak,
        totalDaysLogged: totalDaysLogged,
      )) {
        eligible.add(rule.id);
      }
    }

    return eligible;
  }

  Set<RewardId> mergeUnlocked(Set<RewardId> stored, Set<RewardId> eligible) {
    return {...stored, ...eligible};
  }

  bool _isConditionMet(
    RewardCondition condition, {
    required int bestStreak,
    required int totalDaysLogged,
  }) {
    return switch (condition) {
      StreakMilestoneCondition(:final minDays) => bestStreak >= minDays,
      TotalDaysLoggedCondition(:final minDays) => totalDaysLogged >= minDays,
    };
  }
}
