import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/life_week_grid.dart';

/// Pure helpers that derive the data needed by the home-screen widgets from the
/// user profile and recorded days. Kept free of Flutter/`BuildContext` so they
/// can run from a Redux middleware and be unit-tested in isolation.
abstract final class HomeWidgetGridData {
  /// Number of completed years of life at [at] for someone born on
  /// [dateOfBirth]. Returns 0 when [dateOfBirth] is null or in the future.
  ///
  /// A year is "lived" once its calendar anniversary has passed, so the result
  /// is the user's integer age in years, clamped to `[0, projectedLifespanYears]`.
  static int livedYears({
    required DateTime? dateOfBirth,
    required int projectedLifespanYears,
    required DateTime at,
  }) {
    if (dateOfBirth == null) return 0;
    final birth = DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day);
    final today = DateTime(at.year, at.month, at.day);
    if (!today.isAfter(birth)) return 0;

    var age = today.year - birth.year;
    final hadBirthdayThisYear =
        today.month > birth.month || (today.month == birth.month && today.day >= birth.day);
    if (!hadBirthdayThisYear) age -= 1;
    if (age < 0) age = 0;
    if (age > projectedLifespanYears) age = projectedLifespanYears;
    return age;
  }

  /// Builds the per-day fill encoding for the current civil year, mirroring the
  /// in-app [ZoomableLifeGridView] year view:
  /// `-3` today w/o record, `-2` past w/o record, `-1` future w/o record,
  /// `[0, 4]` recorded size level.
  static List<int> yearFillSizes({
    required Iterable<DayEntry> entries,
    required DateTime now,
  }) {
    final year = now.year;
    final totalDays = daysInGregorianYear(year);
    final todayIndex = dayOfYearIndex(DateTime(now.year, now.month, now.day));

    final sizes = List<int>.generate(totalDays, (i) {
      if (i < todayIndex) return -2;
      if (i == todayIndex) return -3;
      return -1;
    });

    for (final entry in entries) {
      if (entry.date.year != year) continue;
      final dayOfYear = dayOfYearIndex(entry.date);
      if (dayOfYear < 0 || dayOfYear >= totalDays) continue;
      sizes[dayOfYear] = entry.sizeLevel;
    }
    return sizes;
  }

  /// Number of days in the civil year of [now] (365 or 366).
  static int yearTotalDays(DateTime now) => daysInGregorianYear(now.year);

  /// Convenience: builds the life-in-weeks grid from the profile.
  static LifeWeekGrid weekGrid({
    required DateTime? dateOfBirth,
    required int projectedLifespanYears,
    required DateTime at,
    int weekStartDay = DateTime.monday,
  }) {
    return LifeWeekGrid.fromProfile(
      dateOfBirth: dateOfBirth,
      projectedLifespanYears: projectedLifespanYears,
      at: at,
      weekStartDay: weekStartDay,
    );
  }
}
