import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_state.dart';

RewardsState rewardsReducer(RewardsState state, dynamic action) {
  if (action is RewardsLoadedAction) {
    return state.copyWith(
      unlocked: action.unlocked,
      pendingCelebration: action.pendingCelebration,
    );
  }

  if (action is RewardsCelebrationDismissedAction) {
    return state.copyWith(pendingCelebration: const {});
  }

  return state;
}
