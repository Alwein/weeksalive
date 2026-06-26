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
      return scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
