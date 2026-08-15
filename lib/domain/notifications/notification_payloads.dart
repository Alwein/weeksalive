abstract final class NotificationPayloads {
  static const dailyReminder = 'daily_reminder';
  static const dailyFollowup = 'daily_followup';
  static const streakSave = 'streak_save';
  static const weeklySummary = 'weekly_summary';

  static const all = [dailyReminder, dailyFollowup, streakSave, weeklySummary];

  static bool isKnown(String? payload) => payload != null && all.contains(payload);
}
