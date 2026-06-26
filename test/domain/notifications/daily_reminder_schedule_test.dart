import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/notifications/daily_reminder_schedule.dart';

void main() {
  group('DailyReminderSchedule.deferWhenTodayLogged', () {
    final now = DateTime(2026, 6, 26, 10);

    test('keeps today when today is not logged yet', () {
      final scheduled = DateTime(2026, 6, 26, 18);

      final result = DailyReminderSchedule.deferWhenTodayLogged(
        scheduledDate: scheduled,
        hasTodayEntry: false,
        now: now,
      );

      expect(result, scheduled);
    });

    test('defers to tomorrow when today is already logged', () {
      final scheduled = DateTime(2026, 6, 26, 18);

      final result = DailyReminderSchedule.deferWhenTodayLogged(
        scheduledDate: scheduled,
        hasTodayEntry: true,
        now: now,
      );

      expect(result, DateTime(2026, 6, 27, 18));
    });

    test('keeps tomorrow when today is already logged', () {
      final scheduled = DateTime(2026, 6, 27, 8);

      final result = DailyReminderSchedule.deferWhenTodayLogged(
        scheduledDate: scheduled,
        hasTodayEntry: true,
        now: now,
      );

      expect(result, scheduled);
    });
  });
}
