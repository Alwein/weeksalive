import 'package:redux/redux.dart';
import 'package:weeksalive/data/rewards/rewards_repository.dart';
import 'package:weeksalive/domain/rewards/reward_unlock_service.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';

class RewardsMiddleware extends MiddlewareClass<AppState> {
  RewardsMiddleware({
    required this.rewardsRepository,
    RewardUnlockService? rewardUnlockService,
  }) : _rewardUnlockService = rewardUnlockService ?? const RewardUnlockService();

  final RewardsRepository rewardsRepository;
  final RewardUnlockService _rewardUnlockService;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is StreakRecalculatedAction) {
      await _syncRewards(store);
    }
  }

  Future<void> _syncRewards(Store<AppState> store) async {
    final bestStreak = store.state.streakState.bestEver;
    final totalDays = store.state.dayState.entries.length;

    final stored = await rewardsRepository.getUnlocked();
    final eligible = _rewardUnlockService.evaluateEligible(
      bestStreak: bestStreak,
      totalDaysLogged: totalDays,
    );
    final newOnes = eligible.difference(stored);
    final merged = _rewardUnlockService.mergeUnlocked(stored, eligible);

    if (merged.length != stored.length) {
      await rewardsRepository.unlock(newOnes);
    }

    try {
      store.dispatch(
        RewardsLoadedAction(
          unlocked: merged,
          pendingCelebration: newOnes,
        ),
      );
    } catch (_) {
      // Store torn down (e.g. in tests) during the async gap.
    }
  }
}
