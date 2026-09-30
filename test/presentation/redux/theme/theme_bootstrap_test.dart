import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_middleware.dart';

import '../../../helpers/test_app_state.dart';

void main() {
  group('theme bootstrap', () {
    Future<(Store<AppState>, ThemeRepository)> buildStore(String storedTheme) async {
      SharedPreferences.setMockInitialValues({'app_theme': storedTheme});
      final repository = ThemeRepository(preferences: await SharedPreferences.getInstance());
      final store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [ThemeMiddleware(themeRepository: repository).call],
      );
      return (store, repository);
    }

    test('keeps an always-unlocked theme before rewards are loaded', () async {
      final (store, repository) = await buildStore('petale');

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();

      expect(store.state.themeState.selectedTheme, AppThemeId.petale);
      expect(await repository.getSelectedTheme(), AppThemeId.petale);
    });

    test('restores a reward theme once rewards load after bootstrap', () async {
      final (store, repository) = await buildStore('matcha');

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();
      store.dispatch(const RewardsLoadedAction(unlocked: {RewardId.themeMatcha}));
      await pumpEventQueue();

      expect(store.state.themeState.selectedTheme, AppThemeId.matcha);
      expect(await repository.getSelectedTheme(), AppThemeId.matcha);
    });

    test('falls back to system when the stored reward theme is not unlocked', () async {
      final (store, repository) = await buildStore('matcha');

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();
      store.dispatch(const RewardsLoadedAction(unlocked: {}));
      await pumpEventQueue();

      expect(store.state.themeState.selectedTheme, AppThemeId.system);
      expect(await repository.getSelectedTheme(), AppThemeId.system);
    });
  });
}
