import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/domain/theme/theme_unlock_condition.dart';

class ThemeUnlockRule {
  const ThemeUnlockRule({
    required this.themeId,
    required this.condition,
  });

  final AppThemeId themeId;
  final ThemeUnlockCondition condition;
}
