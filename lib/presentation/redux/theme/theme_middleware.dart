import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/domain/theme/theme_unlock_service.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';

class ThemeMiddleware extends MiddlewareClass<AppState> {
  final ThemeRepository themeRepository;
  final ThemeUnlockService themeUnlockService;

  ThemeMiddleware({
    required this.themeRepository,
    ThemeUnlockService? themeUnlockService,
  }) : themeUnlockService = themeUnlockService ?? const ThemeUnlockService();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final selectedTheme = await themeRepository.getSelectedTheme();
      final unlockedThemes = _computeUnlocked(store);
      await themeRepository.setUnlockedThemes(unlockedThemes);
      try {
        store.dispatch(
          AppThemeLoadedAction(
            selectedTheme: selectedTheme,
            unlockedThemes: unlockedThemes,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SetAppThemeAction) {
      if (!store.state.themeState.unlockedThemes.contains(action.themeId)) return;
      await themeRepository.setSelectedTheme(action.themeId);
      try {
        store.dispatch(
          AppThemeLoadedAction(
            selectedTheme: action.themeId,
            unlockedThemes: store.state.themeState.unlockedThemes,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SetStreakCountAction) {
      await _refreshUnlockedThemes(store);
    }
  }

  Future<void> _refreshUnlockedThemes(Store<AppState> store) async {
    final unlockedThemes = _computeUnlocked(store);
    if (_setsEqual(unlockedThemes, store.state.themeState.unlockedThemes)) return;

    await themeRepository.setUnlockedThemes(unlockedThemes);
    try {
      store.dispatch(ThemesUnlockedAction(unlockedThemes));
    } catch (_) {
      // Store torn down (e.g. in tests) during the async gap.
    }
  }

  Set<AppThemeId> _computeUnlocked(Store<AppState> store) {
    return themeUnlockService.computeUnlockedThemes(
      streakCount: store.state.streakState.count,
      totalDaysLogged: store.state.dayState.entries.length,
    );
  }

  bool _setsEqual(Set<AppThemeId> a, Set<AppThemeId> b) {
    return a.length == b.length && a.containsAll(b);
  }
}
