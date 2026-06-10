abstract final class NotificationPayloads {
  static const dailyReminder = 'daily_reminder';
  static const weeklySummary = 'weekly_summary';

  static bool isKnown(String? payload) =>
      payload == dailyReminder || payload == weeklySummary;
}
