import 'package:weeksalive/domain/rewards/reward_id.dart';

class RewardsState {
  final Set<RewardId> unlocked;
  final Set<RewardId> pendingCelebration;

  const RewardsState({
    this.unlocked = const {},
    this.pendingCelebration = const {},
  });

  RewardsState copyWith({
    Set<RewardId>? unlocked,
    Set<RewardId>? pendingCelebration,
  }) {
    return RewardsState(
      unlocked: unlocked ?? this.unlocked,
      pendingCelebration: pendingCelebration ?? this.pendingCelebration,
    );
  }
}
