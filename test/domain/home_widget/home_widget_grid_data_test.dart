import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/home_widget/home_widget_grid_data.dart';

void main() {
  group('HomeWidgetGridData.livedYears', () {
    test('null date of birth yields zero', () {
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: null,
          projectedLifespanYears: 85,
          at: DateTime(2026, 6, 12),
        ),
        0,
      );
    });

    test('counts full years when the birthday has already passed this year', () {
      // Born June 15, 1990; on June 16, 2020 the 30th birthday has passed.
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: DateTime(1990, 6, 15),
          projectedLifespanYears: 85,
          at: DateTime(2020, 6, 16),
        ),
        30,
      );
    });

    test('does not count the current year before the birthday', () {
      // Born June 15, 1990; on June 14, 2020 the 30th birthday has NOT passed.
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: DateTime(1990, 6, 15),
          projectedLifespanYears: 85,
          at: DateTime(2020, 6, 14),
        ),
        29,
      );
    });

    test('counts the birthday itself as a completed year', () {
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: DateTime(1990, 6, 15),
          projectedLifespanYears: 85,
          at: DateTime(2020, 6, 15),
        ),
        30,
      );
    });

    test('clamps to the projected lifespan', () {
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: DateTime(1900, 1, 1),
          projectedLifespanYears: 80,
          at: DateTime(2026, 6, 12),
        ),
        80,
      );
    });

    test('returns zero for a future date of birth', () {
      expect(
        HomeWidgetGridData.livedYears(
          dateOfBirth: DateTime(2030, 1, 1),
          projectedLifespanYears: 85,
          at: DateTime(2026, 6, 12),
        ),
        0,
      );
    });
  });

  group('HomeWidgetGridData.yearFillSizes', () {
    test('marks past, today and future days with the expected sentinels', () {
      final now = DateTime(2026, 6, 12);
      final sizes = HomeWidgetGridData.yearFillSizes(entries: const [], now: now);

      expect(sizes.length, daysInGregorianYear(2026));
      final todayIndex = dayOfYearIndex(now);

      expect(sizes[todayIndex], -3, reason: 'today without record');
      expect(sizes[todayIndex - 1], -2, reason: 'past without record');
      expect(sizes[todayIndex + 1], -1, reason: 'future without record');
    });

    test('overrides days that have a recorded entry with their size level', () {
      final now = DateTime(2026, 6, 12);
      final recorded = DayEntry(date: DateTime(2026, 3, 10), sizeLevel: 4);
      final sizes = HomeWidgetGridData.yearFillSizes(entries: [recorded], now: now);

      final index = dayOfYearIndex(DateTime(2026, 3, 10));
      expect(sizes[index], 4);
    });

    test('ignores entries from other years', () {
      final now = DateTime(2026, 6, 12);
      final recorded = DayEntry(date: DateTime(2025, 3, 10), sizeLevel: 4);
      final sizes = HomeWidgetGridData.yearFillSizes(entries: [recorded], now: now);

      final index = dayOfYearIndex(DateTime(2026, 3, 10));
      expect(sizes[index], -2, reason: 'unchanged past sentinel');
    });
  });
}
