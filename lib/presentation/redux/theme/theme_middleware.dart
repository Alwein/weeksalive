import 'package:redux/redux.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';

class ThemeMiddleware extends MiddlewareClass<AppState> {
  final ThemeRepository themeRepository;

  ThemeMiddleware({required this.themeRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction || action is DataRestoredAction) {
      final selectedTheme = await themeRepository.getSelectedTheme();
      try {
        store.dispatch(
          AppThemeLoadedAction(
            selectedTheme: selectedTheme,
            unlockedThemes: store.state.themeState.unlockedThemes,
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

    if (action is RewardsLoadedAction) {
      final unlockedThemes = {
        ...AppThemeId.alwaysUnlocked,
        ...rewardIdsToThemeIds(action.unlocked),
      };
      // Read the persisted choice rather than the state: at bootstrap the theme
      // is loaded before rewards, so a reward theme was downgraded to system.
      final selected = await themeRepository.getSelectedTheme();
      try {
        store.dispatch(ThemesUnlockedAction(unlockedThemes));
        if (unlockedThemes.contains(selected)) {
          if (store.state.themeState.selectedTheme != selected) {
            store.dispatch(
              AppThemeLoadedAction(
                selectedTheme: selected,
                unlockedThemes: unlockedThemes,
              ),
            );
          }
        } else {
          await themeRepository.setSelectedTheme(AppThemeId.system);
          store.dispatch(
            AppThemeLoadedAction(
              selectedTheme: AppThemeId.system,
              unlockedThemes: unlockedThemes,
            ),
          );
        }
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }
  }
}
