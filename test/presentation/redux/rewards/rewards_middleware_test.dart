import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_middleware.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

Store<AppState> _rewardsStore({
  required RewardsMiddleware rewardsMiddleware,
  AppState? initialState,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState ?? initialAppState(),
    middleware: [rewardsMiddleware.call],
  );
}

void main() {
  group('RewardsMiddleware', () {
    late MockRewardsRepository repository;
    late RewardsMiddleware middleware;

    setUp(() {
      repository = MockRewardsRepository();
      middleware = RewardsMiddleware(rewardsRepository: repository);
    });

    test('keeps previously unlocked rewards when streak drops', () async {
      when(() => repository.getUnlocked()).thenAnswer((_) async => {RewardId.themeArdoise});

      final store = _rewardsStore(
        rewardsMiddleware: middleware,
        initialState: initialAppState().copyWith(
          streakState: initialAppState().streakState.copyWith(count: 0, bestEver: 0),
        ),
      );

      await store.dispatch(const StreakRecalculatedAction(count: 0, bestEver: 0));
      await pumpEventQueue();

      expect(store.state.rewardsState.unlocked, contains(RewardId.themeArdoise));
    });

    test('unlocks newly eligible rewards and updates themes', () async {
      when(() => repository.getUnlocked()).thenAnswer((_) async => {});
      when(() => repository.unlock(any())).thenAnswer((_) async {});

      final themeMiddleware = ThemeMiddleware(themeRepository: MockThemeRepository());
      final store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [middleware.call, themeMiddleware.call],
      );

      await store.dispatch(const StreakRecalculatedAction(count: 30, bestEver: 30));
      await pumpEventQueue();

      expect(store.state.rewardsState.unlocked, contains(RewardId.themeMatcha));
      expect(store.state.rewardsState.pendingCelebration, contains(RewardId.themeMatcha));
    });
  });
}
