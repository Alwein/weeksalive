import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/theme/theme_unlock_condition.dart';
import 'package:weeksalive/domain/theme/theme_unlock_rule.dart';
import 'package:weeksalive/domain/theme/theme_unlock_service.dart';

void main() {
  group('ThemeUnlockService', () {
    test('always unlocks base themes', () {
      const service = ThemeUnlockService();
      final unlocked = service.computeUnlockedThemes(streakCount: 0, totalDaysLogged: 0);
      expect(unlocked, containsAll(AppThemeId.alwaysUnlocked));
    });

    test('unlocks themes when rules are met', () {
      const service = ThemeUnlockService(
        rules: [
          ThemeUnlockRule(
            themeId: AppThemeId.petale,
            condition: StreakUnlockCondition(7),
          ),
          ThemeUnlockRule(
            themeId: AppThemeId.cafe,
            condition: TotalDaysLoggedCondition(10),
          ),
        ],
      );

      final unlocked = service.computeUnlockedThemes(streakCount: 7, totalDaysLogged: 5);
      expect(unlocked, contains(AppThemeId.petale));
      expect(unlocked, isNot(contains(AppThemeId.cafe)));

      final unlockedWithDays = service.computeUnlockedThemes(streakCount: 1, totalDaysLogged: 10);
      expect(unlockedWithDays, contains(AppThemeId.cafe));
    });
  });
}
