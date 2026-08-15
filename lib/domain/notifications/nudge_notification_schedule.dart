import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/notifications/daily_reminder_schedule.dart';

/// When to fire the same-day follow-up and the next-morning streak save.
///
/// Follow-up: only if the user has a single daily slot. Two slots already
/// provide a later reminder, so a third notification would burn the channel.
/// Streak save: only when a streak is at risk, and never on the weekly recap
/// morning (one morning notification is enough).
abstract final class NudgeNotificationSchedule {
  static const followUpDelay = Duration(minutes: 90);
  static const followUpLatestHour = 22;
  static const followUpLatestMinute = 45;
  static const streakSaveHour = 10;
  static const streakSaveMinute = 0;

  /// Next follow-up after the single daily slot, or `null` if none should fire.
  static DateTime? followUpDate({
    required int slotHour,
    required int slotMinute,
    required int enabledDailySlotCount,
    required bool hasTodayEntry,
    required DateTime now,
  }) {
    if (enabledDailySlotCount != 1) return null;

    var routine = DateTime(now.year, now.month, now.day, slotHour, slotMinute);
    if (routine.isBefore(now)) {
      routine = routine.add(const Duration(days: 1));
    }
    routine = DailyReminderSchedule.deferWhenTodayLogged(
      scheduledDate: routine,
      hasTodayEntry: hasTodayEntry,
      now: now,
    );

    final followUp = routine.add(followUpDelay);
    if (normalizeDay(followUp) != normalizeDay(routine)) return null;
    if (_minutesSinceMidnight(followUp) > _minutesSinceMidnightOf(followUpLatestHour, followUpLatestMinute)) {
      return null;
    }
    if (!followUp.isAfter(now)) return null;
    return followUp;
  }

  /// Next streak-save notification, or `null` if none should fire.
  ///
  /// Prefers today's 10:00 when yesterday is still in the grace window.
  /// Otherwise pre-schedules tomorrow 10:00 when today is not logged yet.
  static DateTime? streakSaveDate({
    required int streakCount,
    required bool hasTodayEntry,
    required bool isYesterdayGracePeriod,
    required bool weeklySummaryEnabled,
    required int weekStartDay,
    required DateTime now,
  }) {
    if (streakCount <= 0) return null;

    final today = normalizeDay(now);
    final tomorrow = today.add(const Duration(days: 1));

    if (isYesterdayGracePeriod) {
      final todaySave = _atStreakSaveTime(today);
      if (todaySave.isAfter(now) && !_skipForWeeklyRecap(today, weeklySummaryEnabled, weekStartDay)) {
        return todaySave;
      }
    }

    if (!hasTodayEntry) {
      final tomorrowSave = _atStreakSaveTime(tomorrow);
      if (!_skipForWeeklyRecap(tomorrow, weeklySummaryEnabled, weekStartDay)) {
        return tomorrowSave;
      }
    }

    return null;
  }

  static DateTime _atStreakSaveTime(DateTime day) {
    final normalized = normalizeDay(day);
    return DateTime(normalized.year, normalized.month, normalized.day, streakSaveHour, streakSaveMinute);
  }

  static bool _skipForWeeklyRecap(DateTime day, bool weeklySummaryEnabled, int weekStartDay) {
    return weeklySummaryEnabled && normalizeDay(day).weekday == weekStartDay;
  }

  static int _minutesSinceMidnight(DateTime value) => value.hour * 60 + value.minute;

  static int _minutesSinceMidnightOf(int hour, int minute) => hour * 60 + minute;
}
