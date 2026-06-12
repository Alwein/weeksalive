import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_state.dart';

ThemeState themeReducer(ThemeState state, dynamic action) {
  if (action is AppThemeLoadedAction) {
    final selected = action.unlockedThemes.contains(action.selectedTheme) ? action.selectedTheme : AppThemeId.system;
    return state.copyWith(
      selectedTheme: selected,
      unlockedThemes: action.unlockedThemes,
    );
  }

  if (action is SetAppThemeAction) {
    if (!state.unlockedThemes.contains(action.themeId)) return state;
    return state.copyWith(selectedTheme: action.themeId);
  }

  if (action is ThemesUnlockedAction) {
    final unlocked = {...action.unlockedThemes, ...AppThemeId.alwaysUnlocked};
    final selected = unlocked.contains(state.selectedTheme) ? state.selectedTheme : AppThemeId.system;
    return state.copyWith(unlockedThemes: unlocked, selectedTheme: selected);
  }

  return state;
}
