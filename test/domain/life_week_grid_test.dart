import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/life_week_grid.dart';

void main() {
  group('LifeWeekGrid.fromProfile', () {
    test('null date of birth falls back to 52 weeks per year, zero lived', () {
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: null,
        projectedLifespanYears: 85,
        at: DateTime.utc(2026, 5, 3),
      );
      expect(grid.totalWeeks, 85 * 52);
      expect(grid.livedWeeks, 0);
      expect(grid.progressFraction, 0);
    });

    test('lived weeks are full weeks since birth, not age in years plus weeks', () {
      final dob = DateTime.utc(1990, 6, 15);
      final at = DateTime.utc(2020, 6, 15);
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: dob,
        projectedLifespanYears: 85,
        at: at,
      );
      // Exactly 30 calendar years → same as 30 * ~365.25 days floored to weeks
      final expectedLived = at.difference(dob).inDays ~/ 7;
      expect(grid.livedWeeks, expectedLived);
      expect(grid.livedWeeks, isNot(30 + expectedLived));
    });

    test('total weeks span from birth to Nth birthday, not lifespan * 52', () {
      final dob = DateTime.utc(2000, 1, 1);
      const lifespanYears = 80;
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: dob,
        projectedLifespanYears: lifespanYears,
        at: DateTime.utc(2026, 1, 1),
      );
      final end = addCalendarYears(dob, lifespanYears);
      final expectedTotal = end.difference(dob).inDays ~/ 7;
      expect(grid.totalWeeks, expectedTotal);
      expect(grid.totalWeeks, isNot(lifespanYears * 52));
    });

    test('caps lived weeks at total when at is past projected end', () {
      final dob = DateTime.utc(1990, 1, 1);
      const lifespanYears = 40;
      final at = DateTime.utc(2040, 6, 1);
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: dob,
        projectedLifespanYears: lifespanYears,
        at: at,
      );
      expect(grid.livedWeeks, grid.totalWeeks);
      expect(grid.progressFraction, 1.0);
    });

    test('at or before birth yields zero lived weeks', () {
      final dob = DateTime.utc(2000, 5, 10);
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: dob,
        projectedLifespanYears: 90,
        at: DateTime.utc(2000, 5, 10),
      );
      expect(grid.livedWeeks, 0);
    });
  });

  group('totalWeeksFromBirthToAgeAnniversary', () {
    test('matches difference in days for a non-leap span', () {
      final dob = DateTime.utc(1995, 3, 10);
      const years = 10;
      final total = totalWeeksFromBirthToAgeAnniversary(dateOfBirth: dob, ageYears: years);
      final end = addCalendarYears(dob, years);
      expect(total, end.difference(dob).inDays ~/ 7);
    });
  });
}
