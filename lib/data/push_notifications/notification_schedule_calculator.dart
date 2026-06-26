import 'package:timezone/timezone.dart' as tz;

abstract final class NotificationScheduleCalculator {
  static tz.TZDateTime nextDailyOccurrence(int hour, int minute, {tz.TZDateTime? now}) {
    final effectiveNow = now ?? tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, effectiveNow.year, effectiveNow.month, effectiveNow.day, hour, minute);
    if (scheduled.isBefore(effectiveNow)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime nextWeeklyOccurrence(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
      scheduled = tz.TZDateTime(
        tz.local,
        scheduled.year,
        scheduled.month,
        scheduled.day,
        hour,
        minute,
      );
    }
    return scheduled;
  }
}
