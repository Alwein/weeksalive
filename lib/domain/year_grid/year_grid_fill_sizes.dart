import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';

/// Fill size of a past day with no record, drawn as a soft filled dot.
const yearGridPastEmpty = -2;

/// Fill size of today when it has no record yet, drawn in the accent color.
const yearGridTodayEmpty = -3;

/// Fill size of a day still ahead, drawn as an empty circle.
const yearGridFuture = -1;

/// One entry per day of [now]'s year, in the encoding the year grid draws:
/// [yearGridPastEmpty], [yearGridTodayEmpty], [yearGridFuture], or the
/// recorded size level (`0..4`) of an entry.
List<int> yearGridFillSizes({
  required Iterable<DayEntry> entries,
  required DateTime now,
}) {
  final year = now.year;
  final totalDays = daysInGregorianYear(year);
  final todayIndex = dayOfYearIndex(now);
  final sizes = List<int>.generate(totalDays, (i) {
    if (i < todayIndex) return yearGridPastEmpty;
    if (i == todayIndex) return yearGridTodayEmpty;
    return yearGridFuture;
  });
  for (final entry in entries) {
    if (entry.date.year != year) continue;
    final dayOfYear = dayOfYearIndex(entry.date);
    if (dayOfYear < 0 || dayOfYear >= totalDays) continue;
    sizes[dayOfYear] = entry.sizeLevel;
  }
  return sizes;
}
