import 'package:weeksalive/domain/day/day_entry.dart';

/// Business rules for when daily form reminders should fire.
abstract final class DailyReminderSchedule {
  /// Defers [scheduledDate] by one day when the user already logged today.
  static DateTime deferWhenTodayLogged({
    required DateTime scheduledDate,
    required bool hasTodayEntry,
    required DateTime now,
  }) {
    if (hasTodayEntry && normalizeDay(scheduledDate) == normalizeDay(now)) {
      // Same wall-clock time tomorrow, which is not 24 hours away when the
      // clocks change tonight.
      return DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day + 1,
        scheduledDate.hour,
        scheduledDate.minute,
        scheduledDate.second,
      );
    }
    return scheduledDate;
  }
}
