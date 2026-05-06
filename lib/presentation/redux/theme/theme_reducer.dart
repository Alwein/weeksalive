import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_state.dart';

ThemeState themeReducer(ThemeState state, dynamic action) {
  if (action is ThemeModeLoadedAction) {
    return state.copyWith(themeMode: action.themeMode);
  }
  return state;
}
