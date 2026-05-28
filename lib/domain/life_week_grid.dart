class LifeWeekGrid {
  const LifeWeekGrid({required this.totalWeeks, required this.livedWeeks});

  final int totalWeeks;
  final int livedWeeks;

  double get progressFraction {
    if (totalWeeks <= 0) return 0;
    return (livedWeeks / totalWeeks).clamp(0.0, 1.0);
  }

  factory LifeWeekGrid.fromProfile({
    required DateTime? dateOfBirth,
    required int projectedLifespanYears,
    required DateTime at,
  }) {
    if (dateOfBirth == null) {
      final total = projectedLifespanYears * 52;
      return LifeWeekGrid(totalWeeks: total, livedWeeks: 0);
    }
    final total = totalWeeksFromBirthToAgeAnniversary(
      dateOfBirth: dateOfBirth,
      ageYears: projectedLifespanYears,
    );
    var lived = weeksSinceBirth(dateOfBirth: dateOfBirth, at: at);
    if (lived > total) lived = total;
    return LifeWeekGrid(totalWeeks: total, livedWeeks: lived);
  }
}

int totalWeeksFromBirthToAgeAnniversary({
  required DateTime dateOfBirth,
  required int ageYears,
}) {
  final end = addCalendarYears(dateOfBirth, ageYears);
  return end.difference(dateOfBirth).inDays ~/ 7;
}

int weeksSinceBirth({required DateTime dateOfBirth, required DateTime at}) {
  if (!at.isAfter(dateOfBirth)) return 0;
  return at.difference(dateOfBirth).inDays ~/ 7;
}

DateTime addCalendarYears(DateTime d, int years) {
  return DateTime(
    d.year + years,
    d.month,
    d.day,
    d.hour,
    d.minute,
    d.second,
    d.millisecond,
    d.microsecond,
  );
}

/// Result of a "lived vs ahead" partition of grid dot indices.
class LivedAheadDots {
  const LivedAheadDots({required this.lived, required this.ahead});

  final List<int> lived;
  final List<int> ahead;
}

/// Returns the indices of the first week of each year of life, partitioned
/// into already lived (index < [livedWeeks]) and still ahead.
///
/// Each row of the life grid spans one year of life, so the first cell of each
/// row falls on (or right after) the user's birthday.
LivedAheadDots birthdayDotIndices({
  required int totalWeeks,
  required int livedWeeks,
  int columns = 52,
}) {
  if (totalWeeks <= 0) return const LivedAheadDots(lived: [], ahead: []);
  final totalRows = (totalWeeks / columns).ceil();
  final lived = <int>[];
  final ahead = <int>[];
  for (var year = 0; year < totalRows; year++) {
    final index = year * columns;
    if (index >= totalWeeks) break;
    if (index < livedWeeks) {
      lived.add(index);
    } else {
      ahead.add(index);
    }
  }
  return LivedAheadDots(lived: lived, ahead: ahead);
}

/// Returns the column offsets within a [columns]-wide row that correspond to
/// the weeks where [predicate] is true, based on the calendar dates of the
/// first year of life starting on [dateOfBirth].
///
/// Using the offsets of the first year for every row keeps the highlighted
/// dots aligned vertically across the grid, even though one row spans
/// `52 * 7 = 364` days while a calendar year is ~365.25 days (otherwise the
/// highlighted weeks would drift by roughly one column every ~5 years).
List<int> _seasonalColumnOffsets({
  required DateTime dateOfBirth,
  required int columns,
  required bool Function(DateTime date) predicate,
}) {
  final offsets = <int>[];
  for (var w = 0; w < columns; w++) {
    final date = dateOfBirth.add(Duration(days: w * 7));
    if (predicate(date)) offsets.add(w);
  }
  return offsets;
}

/// Returns the indices of the weeks that fall in the northern hemisphere
/// winter (December, January, February), partitioned into already lived and
/// still ahead. The same column offsets (relative to the user's birthday) are
/// reused for every year of life so the highlighted weeks stay aligned
/// vertically across the grid.
LivedAheadDots winterDotIndices({
  required DateTime? dateOfBirth,
  required int totalWeeks,
  required int livedWeeks,
  int columns = 52,
}) {
  if (dateOfBirth == null || totalWeeks <= 0) {
    return const LivedAheadDots(lived: [], ahead: []);
  }
  final offsets = _seasonalColumnOffsets(
    dateOfBirth: dateOfBirth,
    columns: columns,
    predicate: (d) => d.month == 12 || d.month == 1 || d.month == 2,
  );
  if (offsets.isEmpty) return const LivedAheadDots(lived: [], ahead: []);

  final totalRows = (totalWeeks / columns).ceil();
  final lived = <int>[];
  final ahead = <int>[];
  for (var year = 0; year < totalRows; year++) {
    for (final offset in offsets) {
      final i = year * columns + offset;
      if (i >= totalWeeks) break;
      if (i < livedWeeks) {
        lived.add(i);
      } else {
        ahead.add(i);
      }
    }
  }
  return LivedAheadDots(lived: lived, ahead: ahead);
}

/// Returns the indices of the weeks that fall during a Summer Olympic games
/// event, partitioned into already lived and still ahead. The Summer Olympics
/// happen every 4 years (e.g. 2024, 2028…) and last roughly 17 days, so we
/// approximate with weeks falling in the second half of July or August of an
/// Olympic year.
///
/// To keep the highlighted dots aligned vertically across the grid, we reuse
/// the column offsets of "late July → August" computed from the first year of
/// life and we simply skip non-Olympic rows (years).
LivedAheadDots olympicsDotIndices({
  required DateTime? dateOfBirth,
  required int totalWeeks,
  required int livedWeeks,
  int columns = 52,
}) {
  if (dateOfBirth == null || totalWeeks <= 0) {
    return const LivedAheadDots(lived: [], ahead: []);
  }
  final offsets = _seasonalColumnOffsets(
    dateOfBirth: dateOfBirth,
    columns: columns,
    predicate: (d) => (d.month == 7 && d.day >= 15) || d.month == 8,
  );
  if (offsets.isEmpty) return const LivedAheadDots(lived: [], ahead: []);

  final totalRows = (totalWeeks / columns).ceil();
  final lived = <int>[];
  final ahead = <int>[];
  for (var year = 0; year < totalRows; year++) {
    final calendarYear = dateOfBirth.year + year;
    if (calendarYear % 4 != 0) continue;
    for (final offset in offsets) {
      final i = year * columns + offset;
      if (i >= totalWeeks) break;
      if (i < livedWeeks) {
        lived.add(i);
      } else {
        ahead.add(i);
      }
    }
  }
  return LivedAheadDots(lived: lived, ahead: ahead);
}
