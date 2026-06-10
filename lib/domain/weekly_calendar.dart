/// Calendar-week utilities anchored on a user-defined [weekStartDay]
/// (ISO weekday: 1 = Monday … 7 = Sunday).
abstract final class WeeklyCalendar {
  static DateTime normalizeDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime weekStartDate(DateTime date, int weekStartDay) {
    final normalized = normalizeDay(date);
    final offset = (normalized.weekday - weekStartDay) % 7;
    return DateTime(normalized.year, normalized.month, normalized.day - offset);
  }

  static List<DateTime> weekDays(DateTime date, int weekStartDay) {
    final start = weekStartDate(date, weekStartDay);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static List<DateTime> previousWeekDays(DateTime date, int weekStartDay) {
    final start = weekStartDate(date, weekStartDay).subtract(const Duration(days: 7));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static String weekKey(DateTime date, int weekStartDay) {
    final start = weekStartDate(date, weekStartDay);
    final month = start.month.toString().padLeft(2, '0');
    final day = start.day.toString().padLeft(2, '0');
    return '${start.year}-$month-$day';
  }

  static bool shouldShowWeeklySummary({
    required DateTime now,
    required int weekStartDay,
    required DateTime userCreatedAt,
    required String? lastCompletedWeekKey,
  }) {
    final currentKey = weekKey(now, weekStartDay);
    final firstWeekKey = weekKey(userCreatedAt, weekStartDay);

    if (currentKey == firstWeekKey && lastCompletedWeekKey == null) {
      return false;
    }

    if (lastCompletedWeekKey == currentKey) {
      return false;
    }

    return true;
  }
}
