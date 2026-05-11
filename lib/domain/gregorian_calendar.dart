/// Returns the number of days in [year] in the Gregorian calendar (365 or 366).
int daysInGregorianYear(int year) {
  return DateTime(year + 1, 1, 1).difference(DateTime(year, 1, 1)).inDays;
}
