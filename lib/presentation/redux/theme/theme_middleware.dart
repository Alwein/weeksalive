import 'package:redux/redux.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';

class ThemeMiddleware extends MiddlewareClass<AppState> {
  final ThemeRepository themeRepository;

  ThemeMiddleware({required this.themeRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final themeMode = await themeRepository.getThemeMode();
      store.dispatch(ThemeModeLoadedAction(themeMode));
    }

    if (action is SetThemeModeAction) {
      await themeRepository.setThemeMode(action.themeMode);
      store.dispatch(ThemeModeLoadedAction(action.themeMode));
    }
  }
}
