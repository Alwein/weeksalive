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

    test('lived weeks count weekStartDay boundaries crossed since birth', () {
      // 1990-06-15 is a Friday.
      final dob = DateTime.utc(1990, 6, 15);
      final at = DateTime.utc(2020, 6, 15);
      final grid = LifeWeekGrid.fromProfile(
        dateOfBirth: dob,
        projectedLifespanYears: 85,
        at: at,
        weekStartDay: DateTime.monday,
      );
      final expectedLived = weeksSinceBirth(
        dateOfBirth: dob,
        at: at,
        weekStartDay: DateTime.monday,
      );
      expect(grid.livedWeeks, expectedLived);
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

  group('weeksSinceBirth (weekStartDay)', () {
    test('returns zero before the first weekStartDay after birth', () {
      // 2000-01-01 is a Saturday; first Monday after birth is 2000-01-03.
      final dob = DateTime.utc(2000, 1, 1);
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, 2), weekStartDay: DateTime.monday),
        0,
      );
    });

    test('adds a cell exactly on the weekStartDay', () {
      // 2000-01-01 is a Saturday; first Monday after birth is 2000-01-03.
      final dob = DateTime.utc(2000, 1, 1);
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, 3), weekStartDay: DateTime.monday),
        1,
      );
    });

    test('does not advance between two consecutive weekStartDays', () {
      final dob = DateTime.utc(2000, 1, 1);
      for (final day in [4, 5, 6, 7, 8, 9]) {
        expect(
          weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, day), weekStartDay: DateTime.monday),
          1,
          reason: '2000-01-$day should still be in the first counted week',
        );
      }
      // Next Monday is 2000-01-10.
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, 10), weekStartDay: DateTime.monday),
        2,
      );
    });

    test('weekStartDay equal to birth weekday counts the next occurrence, not birth day', () {
      // 2000-01-01 is a Saturday.
      final dob = DateTime.utc(2000, 1, 1);
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: dob, weekStartDay: DateTime.saturday),
        0,
      );
      // Next Saturday is 2000-01-08.
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, 8), weekStartDay: DateTime.saturday),
        1,
      );
    });

    test('different weekStartDay yields a different first boundary', () {
      // 2000-01-01 is a Saturday.
      final dob = DateTime.utc(2000, 1, 1);
      // First Sunday after birth is 2000-01-02.
      expect(
        weeksSinceBirth(dateOfBirth: dob, at: DateTime.utc(2000, 1, 2), weekStartDay: DateTime.sunday),
        1,
      );
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
