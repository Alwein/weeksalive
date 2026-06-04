/// Returns the number of days in [year] in the Gregorian calendar (365 or 366).
int daysInGregorianYear(int year) {
  final isLeap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  return isLeap ? 366 : 365;
}

/// Proleptic Gregorian day number for [year]/[month]/[day], used as a
/// timezone- and DST-independent ordinal for date arithmetic.
int _epochDayNumber(int year, int month, int day) {
  final a = (14 - month) ~/ 12;
  final y = year + 4800 - a;
  final m = month + 12 * a - 3;
  return day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;
}

/// Zero-based index of [date] within its civil year (Jan 1st == 0), computed
/// in calendar days regardless of daylight-saving transitions.
int dayOfYearIndex(DateTime date) {
  return _epochDayNumber(date.year, date.month, date.day) - _epochDayNumber(date.year, 1, 1);
}

/// Date for the zero-based [index] day within [year] (index 0 == Jan 1st),
/// normalized to midnight and unaffected by daylight-saving transitions.
DateTime dateForDayOfYear(int year, int index) {
  // DateTime normalizes day overflow into the right month/year.
  return DateTime(year, 1, 1 + index);
}
