import 'package:weeksalive/domain/rewards/reward_id.dart';

class RewardsLoadedAction {
  final Set<RewardId> unlocked;
  final Set<RewardId> pendingCelebration;

  const RewardsLoadedAction({
    required this.unlocked,
    this.pendingCelebration = const {},
  });
}

class RewardsCelebrationDismissedAction {
  const RewardsCelebrationDismissedAction();
}
