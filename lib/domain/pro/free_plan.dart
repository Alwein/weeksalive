import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';

/// What a free user can do with their days. Pro lifts every limit here.
///
/// Free covers the daily loop: logging today, saving yesterday while its streak
/// grace window is open, and rereading or editing the last [historyDays] days.
/// Older days and missed days are Pro: their value grows with what the user
/// has already recorded.
abstract final class FreePlan {
  /// Number of calendar days a free user can reopen, today included.
  static const historyDays = 7;

  /// Whether a free user can read the entry recorded for [date].
  static bool canReadDay(DateTime date, DateTime now) {
    final daysAgo = calendarDaysBetween(date, now);
    return daysAgo < historyDays;
  }

  /// Whether a free user can open the day form for [date].
  ///
  /// A day without entry whose grace window has closed is a missed day, which
  /// only Pro can catch up on.
  static bool canOpenDayForm({
    required DateTime date,
    required bool hasEntry,
    required DateTime now,
  }) {
    if (isWithinStreakGraceWindow(date, now)) return true;
    return hasEntry && canReadDay(date, now);
  }
}
