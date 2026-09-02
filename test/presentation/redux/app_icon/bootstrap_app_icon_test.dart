import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_middleware.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('bootstrap app icon sync', () {
    late MockDayRepository dayRepository;
    late MockRewardsRepository rewardsRepository;
    late MockAppIconRepository appIconRepository;

    setUp(() {
      dayRepository = MockDayRepository();
      rewardsRepository = MockRewardsRepository();
      appIconRepository = MockAppIconRepository();

      when(() => appIconRepository.getSelectedIcon()).thenAnswer((_) async => AppIconId.gold);
      when(() => rewardsRepository.getUnlocked()).thenAnswer((_) async => {});
      when(() => rewardsRepository.unlock(any())).thenAnswer((_) async {});
      when(() => dayRepository.getAll()).thenAnswer(
        (_) async => [
          DayEntry(
            date: DateTime(2026, 6, 22),
            savedAt: DateTime(2026, 6, 22, 12),
            hasNewExperience: true,
          ),
        ],
      );
    });

    test('restores persisted reward-unlocked icon when bootstrap loads before rewards', () async {
      when(() => rewardsRepository.getUnlocked()).thenAnswer((_) async => {RewardId.appIconGold});

      final store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [
          DayMiddleware(dayRepository: dayRepository).call,
          RewardsMiddleware(rewardsRepository: rewardsRepository).call,
          AppIconMiddleware(appIconRepository: appIconRepository).call,
        ],
      );

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();

      expect(store.state.appIconState.unlockedIcons, contains(AppIconId.gold));
      expect(store.state.appIconState.selectedIcon, AppIconId.gold);
      expect(store.state.rewardsState.unlocked, contains(RewardId.appIconGold));
    });
  });
}
