sealed class ThemeUnlockCondition {
  const ThemeUnlockCondition();
}

class StreakUnlockCondition extends ThemeUnlockCondition {
  const StreakUnlockCondition(this.minStreak);

  final int minStreak;
}

class TotalDaysLoggedCondition extends ThemeUnlockCondition {
  const TotalDaysLoggedCondition(this.minDays);

  final int minDays;
}
