import 'package:timezone/timezone.dart' as tz;

abstract final class NotificationScheduleCalculator {
  static tz.TZDateTime nextDailyOccurrence(int hour, int minute, {tz.TZDateTime? now}) {
    final effectiveNow = now ?? tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, effectiveNow.year, effectiveNow.month, effectiveNow.day, hour, minute);
    if (scheduled.isBefore(effectiveNow)) {
      // The next calendar day, not 24 hours later: those differ when the
      // clocks change tonight.
      scheduled = tz.TZDateTime(tz.local, effectiveNow.year, effectiveNow.month, effectiveNow.day + 1, hour, minute);
    }
    return scheduled;
  }

  static tz.TZDateTime nextWeeklyOccurrence(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var dayOffset = 0;
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      dayOffset++;
      scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day + dayOffset, hour, minute);
    }
    return scheduled;
  }
}
