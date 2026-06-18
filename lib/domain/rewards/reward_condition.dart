sealed class RewardCondition {
  const RewardCondition();
}

class StreakMilestoneCondition extends RewardCondition {
  const StreakMilestoneCondition(this.minDays);

  final int minDays;
}

class TotalDaysLoggedCondition extends RewardCondition {
  const TotalDaysLoggedCondition(this.minDays);

  final int minDays;
}
