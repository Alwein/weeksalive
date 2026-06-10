import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/weekly_calendar.dart';

void main() {
  group('WeeklyCalendar.weekStartDate', () {
    test('returns Monday when week starts on Monday', () {
      final wednesday = DateTime(2026, 6, 10);
      expect(WeeklyCalendar.weekStartDate(wednesday, DateTime.monday), DateTime(2026, 6, 8));
    });

    test('returns Sunday when week starts on Sunday', () {
      final wednesday = DateTime(2026, 6, 10);
      expect(WeeklyCalendar.weekStartDate(wednesday, DateTime.sunday), DateTime(2026, 6, 7));
    });
  });

  group('WeeklyCalendar.weekKey', () {
    test('formats week start as YYYY-MM-DD', () {
      final wednesday = DateTime(2026, 6, 10);
      expect(WeeklyCalendar.weekKey(wednesday, DateTime.monday), '2026-06-08');
    });
  });

  group('WeeklyCalendar.previousWeekDays', () {
    test('returns the seven days before the current week', () {
      final wednesday = DateTime(2026, 6, 10);
      final days = WeeklyCalendar.previousWeekDays(wednesday, DateTime.monday);

      expect(days, [
        DateTime(2026, 6, 1),
        DateTime(2026, 6, 2),
        DateTime(2026, 6, 3),
        DateTime(2026, 6, 4),
        DateTime(2026, 6, 5),
        DateTime(2026, 6, 6),
        DateTime(2026, 6, 7),
      ]);
    });
  });

  group('WeeklyCalendar.shouldShowWeeklySummary', () {
    const weekStartDay = DateTime.monday;
    final signupWednesday = DateTime(2026, 6, 10);
    final nextWeekWednesday = DateTime(2026, 6, 17);

    test('returns false during signup week when never completed', () {
      expect(
        WeeklyCalendar.shouldShowWeeklySummary(
          now: signupWednesday,
          weekStartDay: weekStartDay,
          userCreatedAt: signupWednesday,
          lastCompletedWeekKey: null,
        ),
        isFalse,
      );
    });

    test('returns false when already completed for current week', () {
      expect(
        WeeklyCalendar.shouldShowWeeklySummary(
          now: nextWeekWednesday,
          weekStartDay: weekStartDay,
          userCreatedAt: signupWednesday,
          lastCompletedWeekKey: '2026-06-15',
        ),
        isFalse,
      );
    });

    test('returns true for a new week not yet completed', () {
      expect(
        WeeklyCalendar.shouldShowWeeklySummary(
          now: nextWeekWednesday,
          weekStartDay: weekStartDay,
          userCreatedAt: signupWednesday,
          lastCompletedWeekKey: '2026-06-08',
        ),
        isTrue,
      );
    });
  });
}
