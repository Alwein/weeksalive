import 'package:weeksalive/core/styles/app_theme_id.dart';

class ThemeState {
  final AppThemeId selectedTheme;
  final Set<AppThemeId> unlockedThemes;

  const ThemeState({
    this.selectedTheme = AppThemeId.system,
    Set<AppThemeId>? unlockedThemes,
  }) : unlockedThemes = unlockedThemes ?? const {AppThemeId.system, AppThemeId.dark, AppThemeId.light};

  ThemeState copyWith({
    AppThemeId? selectedTheme,
    Set<AppThemeId>? unlockedThemes,
  }) {
    return ThemeState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      unlockedThemes: unlockedThemes ?? this.unlockedThemes,
    );
  }
}
