import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/theme/theme_unlock_condition.dart';
import 'package:weeksalive/domain/theme/theme_unlock_rule.dart';

abstract final class ThemeUnlockRules {
  static const List<ThemeUnlockRule> all = [
    ThemeUnlockRule(themeId: AppThemeId.matcha, condition: StreakUnlockCondition(30)),
    ThemeUnlockRule(themeId: AppThemeId.pivoine, condition: StreakUnlockCondition(120)),
    ThemeUnlockRule(themeId: AppThemeId.terracotta, condition: StreakUnlockCondition(210)),
    ThemeUnlockRule(themeId: AppThemeId.ardoise, condition: StreakUnlockCondition(300)),
  ];
}
