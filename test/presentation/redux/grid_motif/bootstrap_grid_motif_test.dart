import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_middleware.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('bootstrap grid motif sync', () {
    late MockDayRepository dayRepository;
    late MockRewardsRepository rewardsRepository;
    late MockGridMotifRepository gridMotifRepository;

    setUp(() {
      dayRepository = MockDayRepository();
      rewardsRepository = MockRewardsRepository();
      gridMotifRepository = MockGridMotifRepository();

      when(() => gridMotifRepository.getSelectedMotif()).thenAnswer((_) async => GridMotifId.flowers);
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

    test('restores persisted reward-unlocked motif when bootstrap loads before rewards', () async {
      when(() => rewardsRepository.getUnlocked()).thenAnswer((_) async => {RewardId.gridMotifFlowers});
      final store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [
          DayMiddleware(dayRepository: dayRepository).call,
          RewardsMiddleware(rewardsRepository: rewardsRepository).call,
          GridMotifMiddleware(gridMotifRepository: gridMotifRepository).call,
        ],
      );

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();

      expect(store.state.gridMotifState.unlockedMotifs, contains(GridMotifId.flowers));
      expect(store.state.gridMotifState.selectedMotif, GridMotifId.flowers);
      expect(store.state.rewardsState.unlocked, contains(RewardId.gridMotifFlowers));
    });

    test('keeps a locked motif while the entitlement loads, then Pro restores it', () async {
      when(() => gridMotifRepository.getSelectedMotif()).thenAnswer((_) async => GridMotifId.moons);
      when(() => gridMotifRepository.setSelectedMotif(any())).thenAnswer((_) async {});
      final store = Store<AppState>(
        appReducer,
        initialState: initialAppState(),
        middleware: [
          DayMiddleware(dayRepository: dayRepository).call,
          RewardsMiddleware(rewardsRepository: rewardsRepository).call,
          GridMotifMiddleware(gridMotifRepository: gridMotifRepository).call,
        ],
      );

      await store.dispatch(BootstrapAction());
      await pumpEventQueue();
      verifyNever(() => gridMotifRepository.setSelectedMotif(any()));

      store.dispatch(const PurchaseSucceededAction(isPro: true));
      await pumpEventQueue();

      expect(store.state.gridMotifState.unlockedMotifs, GridMotifId.all.toSet());
      expect(store.state.gridMotifState.selectedMotif, GridMotifId.moons);
      verifyNever(() => gridMotifRepository.setSelectedMotif(any()));
    });
  });
}
