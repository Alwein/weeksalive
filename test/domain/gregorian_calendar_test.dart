import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';

void main() {
  group('daysInGregorianYear', () {
    test('returns 365 for common years', () {
      expect(daysInGregorianYear(2025), 365);
      expect(daysInGregorianYear(2026), 365);
    });

    test('returns 366 for leap years', () {
      expect(daysInGregorianYear(2024), 366);
      expect(daysInGregorianYear(2000), 366);
    });

    test('century years not divisible by 400 are common years', () {
      expect(daysInGregorianYear(1900), 365);
      expect(daysInGregorianYear(2100), 365);
    });
  });

  group('dayOfYearIndex', () {
    test('January 1st is index 0', () {
      expect(dayOfYearIndex(DateTime(2026, 1, 1)), 0);
    });

    test('December 31st of a common year is index 364', () {
      expect(dayOfYearIndex(DateTime(2026, 12, 31)), 364);
    });

    test('December 31st of a leap year is index 365', () {
      expect(dayOfYearIndex(DateTime(2024, 12, 31)), 365);
    });

    test('counts calendar days across a DST spring-forward transition', () {
      // Europe switches to summer time on 2026-03-29 (a 23h day). A naive
      // Duration-based difference would undercount and return 153 here.
      expect(dayOfYearIndex(DateTime(2026, 6, 4)), 154);
    });

    test('ignores the time-of-day component', () {
      expect(dayOfYearIndex(DateTime(2026, 6, 4, 23, 59)), 154);
      expect(dayOfYearIndex(DateTime(2026, 6, 4, 0, 0, 1)), 154);
    });

    test('leap day shifts subsequent indices by one versus a common year', () {
      expect(dayOfYearIndex(DateTime(2024, 3, 1)), 60);
      expect(dayOfYearIndex(DateTime(2026, 3, 1)), 59);
    });
  });

  group('dateForDayOfYear', () {
    test('index 0 maps to January 1st at midnight', () {
      expect(dateForDayOfYear(2026, 0), DateTime(2026, 1, 1));
    });

    test('reconstructs a date past the DST boundary', () {
      expect(dateForDayOfYear(2026, 154), DateTime(2026, 6, 4));
    });

    test('handles the leap day', () {
      expect(dateForDayOfYear(2024, 59), DateTime(2024, 2, 29));
    });
  });

  group('round-trip dayOfYearIndex <-> dateForDayOfYear', () {
    test('is consistent for every day of a common year', () {
      const year = 2026;
      final total = daysInGregorianYear(year);
      for (var i = 0; i < total; i++) {
        final date = dateForDayOfYear(year, i);
        expect(dayOfYearIndex(date), i, reason: 'index $i -> $date');
      }
    });

    test('is consistent for every day of a leap year', () {
      const year = 2024;
      final total = daysInGregorianYear(year);
      for (var i = 0; i < total; i++) {
        final date = dateForDayOfYear(year, i);
        expect(dayOfYearIndex(date), i, reason: 'index $i -> $date');
      }
    });
  });
}
