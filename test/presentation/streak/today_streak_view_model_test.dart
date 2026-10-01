import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/streak/today_streak_page.dart';

import '../../helpers/test_app_state.dart';
import '../../helpers/test_store_factory.dart';

void main() {
  TodayStreakViewModel buildViewModel({
    required bool isPro,
    required int streak,
    Set<RewardId> earned = const {},
    Set<RewardId> justEarned = const {},
  }) {
    final store = TestStoreFactory().initializeReduxStore(
      initialAppState().copyWith(
        streakState: StreakState(count: streak, bestEver: streak),
        rewardsState: RewardsState(
          unlocked: earned,
          pendingCelebration: justEarned,
        ),
        purchaseState: PurchaseState.success(isPro: isPro),
      ),
    );
    return TodayStreakViewModel.fromStore(store);
  }

  group('TodayStreakViewModel', () {
    test('a milestone reached by a subscriber is told by its length', () {
      final vm = buildViewModel(
        isPro: true,
        streak: 30,
        earned: {
          RewardId.gridMotifFlowers,
          RewardId.appIconDraw,
          RewardId.themeMatcha,
        },
        justEarned: {RewardId.appIconDraw, RewardId.themeMatcha},
      );

      expect(vm.isPro, isTrue);
      expect(vm.reachedMilestoneDays, 30);
    });

    test('between milestones a subscriber sees the next one', () {
      final vm = buildViewModel(
        isPro: true,
        streak: 10,
        earned: {RewardId.gridMotifFlowers},
      );

      expect(vm.reachedMilestoneDays, isNull);
      expect(vm.nextMilestoneDays, 14);
      expect(vm.daysUntilNextReward, 4);
    });

    test('a free user still gets the next reward to earn', () {
      final vm = buildViewModel(
        isPro: false,
        streak: 10,
        earned: {RewardId.gridMotifFlowers},
      );

      expect(vm.isPro, isFalse);
      expect(vm.nextRewardId, RewardId.appIconDraw);
      expect(vm.daysUntilNextReward, 4);
    });

    test('subscribing changes the view model so the sheet rebuilds', () {
      expect(
        buildViewModel(isPro: true, streak: 10),
        isNot(buildViewModel(isPro: false, streak: 10)),
      );
    });
  });
}
