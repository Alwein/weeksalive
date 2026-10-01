import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_state.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';
import 'package:weeksalive/presentation/streak/streaks_page.dart';

import '../../helpers/test_app_state.dart';
import '../../helpers/test_store_factory.dart';

void main() {
  StreaksPageViewModel buildViewModel({
    required bool isPro,
    Set<RewardId> earned = const {},
  }) {
    final store = TestStoreFactory().initializeReduxStore(
      initialAppState().copyWith(
        streakState: const StreakState(count: 10, bestEver: 10),
        rewardsState: RewardsState(unlocked: earned),
        purchaseState: PurchaseState.success(isPro: isPro),
      ),
    );
    return StreaksPageViewModel.create(store);
  }

  StreakRewardItem itemFor(StreaksPageViewModel vm, RewardId id) =>
      vm.rewards.firstWhere((item) => item.rule.id == id);

  group('StreaksPageViewModel', () {
    test('a free user only has the rewards the streak earned', () {
      final vm = buildViewModel(
        isPro: false,
        earned: {RewardId.gridMotifFlowers},
      );

      final flowers = itemFor(vm, RewardId.gridMotifFlowers);
      final matcha = itemFor(vm, RewardId.themeMatcha);
      expect(flowers.isReached, isTrue);
      expect(flowers.isAvailable, isTrue);
      expect(matcha.isReached, isFalse);
      expect(matcha.isAvailable, isFalse);
      expect(vm.canUnlockAllWithPro, isTrue);
    });

    test('pro makes every reward available without reaching it', () {
      final vm = buildViewModel(
        isPro: true,
        earned: {RewardId.gridMotifFlowers},
      );

      expect(vm.rewards.every((item) => item.isAvailable), isTrue);
      expect(
        vm.rewards.where((item) => item.isReached).map((item) => item.rule.id),
        [RewardId.gridMotifFlowers],
      );
      expect(vm.canUnlockAllWithPro, isFalse);
    });

    test('the next milestone stays the one the streak is heading for', () {
      final vm = buildViewModel(
        isPro: true,
        earned: {RewardId.gridMotifFlowers},
      );

      expect(
        vm.rewards.singleWhere((item) => item.isActive).rule.id,
        RewardId.appIconDraw,
      );
    });

    test('a free user who earned everything is not offered Pro', () {
      final vm = buildViewModel(isPro: false, earned: RewardId.values.toSet());

      expect(vm.canUnlockAllWithPro, isFalse);
    });

    test('two view models built from the same state are equal', () {
      expect(buildViewModel(isPro: true), buildViewModel(isPro: true));
    });
  });
}
