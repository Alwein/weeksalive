import 'package:weeksalive/core/styles/app_theme_id.dart';

class SetAppThemeAction {
  final AppThemeId themeId;
  const SetAppThemeAction(this.themeId);
}

class AppThemeLoadedAction {
  final AppThemeId selectedTheme;
  final Set<AppThemeId> unlockedThemes;
  const AppThemeLoadedAction({
    required this.selectedTheme,
    required this.unlockedThemes,
  });
}

class ThemesUnlockedAction {
  final Set<AppThemeId> unlockedThemes;
  const ThemesUnlockedAction(this.unlockedThemes);
}
