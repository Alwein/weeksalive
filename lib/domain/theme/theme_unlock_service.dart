import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/theme/theme_unlock_condition.dart';
import 'package:weeksalive/domain/theme/theme_unlock_rule.dart';
import 'package:weeksalive/domain/theme/theme_unlock_rules.dart';

class ThemeUnlockService {
  const ThemeUnlockService({
    this.rules = ThemeUnlockRules.all,
    // this.unlockChromaticInDebug = kDebugMode,
    this.unlockChromaticInDebug = false,
  });

  final List<ThemeUnlockRule> rules;
  final bool unlockChromaticInDebug;

  Set<AppThemeId> computeUnlockedThemes({
    required int streakCount,
    required int totalDaysLogged,
  }) {
    final unlocked = AppThemeId.alwaysUnlocked.toSet();

    if (unlockChromaticInDebug) {
      unlocked.addAll(AppThemeId.all);
      return unlocked;
    }

    for (final rule in rules) {
      if (_isConditionMet(rule.condition, streakCount: streakCount, totalDaysLogged: totalDaysLogged)) {
        unlocked.add(rule.themeId);
      }
    }

    return unlocked;
  }

  bool _isConditionMet(
    ThemeUnlockCondition condition, {
    required int streakCount,
    required int totalDaysLogged,
  }) {
    return switch (condition) {
      StreakUnlockCondition(:final minStreak) => streakCount >= minStreak,
      TotalDaysLoggedCondition(:final minDays) => totalDaysLogged >= minDays,
    };
  }
}
