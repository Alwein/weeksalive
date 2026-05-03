/// Weeks-based view of a life grid for onboarding (one dot ≈ one week).
class LifeWeekGrid {
  const LifeWeekGrid({required this.totalWeeks, required this.livedWeeks});

  final int totalWeeks;
  final int livedWeeks;

  /// 0.0–1.0 for progress UI.
  double get progressFraction {
    if (totalWeeks <= 0) return 0;
    return (livedWeeks / totalWeeks).clamp(0.0, 1.0);
  }

  /// [projectedLifespanYears] is the age reached at end of life (e.g. 85 → 85th birthday).
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

/// Full weeks from [dateOfBirth] to the same calendar date [ageYears] later
/// (the “Nth birthday” instant used for lifespan in years).
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
