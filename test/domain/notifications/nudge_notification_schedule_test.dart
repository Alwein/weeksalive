import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/notifications/nudge_notification_schedule.dart';

void main() {
  group('NudgeNotificationSchedule.followUpDate', () {
    test('returns slot + 90 minutes when a single slot is still ahead', () {
      final now = DateTime(2026, 6, 26, 10);

      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 21,
        slotMinute: 0,
        enabledDailySlotCount: 1,
        hasTodayEntry: false,
        now: now,
      );

      expect(result, DateTime(2026, 6, 26, 22, 30));
    });

    test('returns null when two daily slots are enabled', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 18,
        slotMinute: 0,
        enabledDailySlotCount: 2,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 10),
      );

      expect(result, isNull);
    });

    test('returns null when no daily slot is enabled', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 21,
        slotMinute: 0,
        enabledDailySlotCount: 0,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 10),
      );

      expect(result, isNull);
    });

    test('schedules tomorrow when today is already logged', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 21,
        slotMinute: 0,
        enabledDailySlotCount: 1,
        hasTodayEntry: true,
        now: DateTime(2026, 6, 26, 10),
      );

      expect(result, DateTime(2026, 6, 27, 22, 30));
    });

    test('schedules tomorrow when the slot has already passed', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 18,
        slotMinute: 0,
        enabledDailySlotCount: 1,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 20),
      );

      expect(result, DateTime(2026, 6, 27, 19, 30));
    });

    test('returns null when follow-up would be after 22:45', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 21,
        slotMinute: 30,
        enabledDailySlotCount: 1,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 10),
      );

      expect(result, isNull);
    });

    test('keeps a follow-up that lands exactly at 22:45', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 21,
        slotMinute: 15,
        enabledDailySlotCount: 1,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 10),
      );

      expect(result, DateTime(2026, 6, 26, 22, 45));
    });

    test('schedules tomorrow when today\'s follow-up has already passed', () {
      final result = NudgeNotificationSchedule.followUpDate(
        slotHour: 18,
        slotMinute: 0,
        enabledDailySlotCount: 1,
        hasTodayEntry: false,
        now: DateTime(2026, 6, 26, 19, 45),
      );

      expect(result, DateTime(2026, 6, 27, 19, 30));
    });
  });

  group('NudgeNotificationSchedule.streakSaveDate', () {
    test('returns null when there is no streak', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 0,
        hasTodayEntry: false,
        isYesterdayGracePeriod: true,
        weeklySummaryEnabled: false,
        weekStartDay: DateTime.monday,
        now: DateTime(2026, 6, 26, 8),
      );

      expect(result, isNull);
    });

    test('schedules today at 10:00 during the grace window', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 12,
        hasTodayEntry: false,
        isYesterdayGracePeriod: true,
        weeklySummaryEnabled: false,
        weekStartDay: DateTime.monday,
        now: DateTime(2026, 6, 26, 8),
      );

      expect(result, DateTime(2026, 6, 26, 10));
    });

    test('falls through to tomorrow when today 10:00 has passed', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 12,
        hasTodayEntry: false,
        isYesterdayGracePeriod: true,
        weeklySummaryEnabled: false,
        weekStartDay: DateTime.monday,
        now: DateTime(2026, 6, 26, 11),
      );

      expect(result, DateTime(2026, 6, 27, 10));
    });

    test('pre-schedules tomorrow when today is not logged', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 5,
        hasTodayEntry: false,
        isYesterdayGracePeriod: false,
        weeklySummaryEnabled: false,
        weekStartDay: DateTime.monday,
        now: DateTime(2026, 6, 26, 20),
      );

      expect(result, DateTime(2026, 6, 27, 10));
    });

    test('returns null when today is logged and grace is closed', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 5,
        hasTodayEntry: true,
        isYesterdayGracePeriod: false,
        weeklySummaryEnabled: false,
        weekStartDay: DateTime.monday,
        now: DateTime(2026, 6, 26, 20),
      );

      expect(result, isNull);
    });

    test('skips today when it is the weekly recap morning', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 8,
        hasTodayEntry: true,
        isYesterdayGracePeriod: true,
        weeklySummaryEnabled: true,
        weekStartDay: DateTime.friday,
        now: DateTime(2026, 6, 26, 8),
      );

      expect(result, isNull);
    });

    test('skips tomorrow when it is the weekly recap morning', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 8,
        hasTodayEntry: false,
        isYesterdayGracePeriod: false,
        weeklySummaryEnabled: true,
        weekStartDay: DateTime.saturday,
        now: DateTime(2026, 6, 26, 20),
      );

      expect(result, isNull);
    });

    test('uses tomorrow when today is recap morning but today is not logged', () {
      final result = NudgeNotificationSchedule.streakSaveDate(
        streakCount: 8,
        hasTodayEntry: false,
        isYesterdayGracePeriod: true,
        weeklySummaryEnabled: true,
        weekStartDay: DateTime.friday,
        now: DateTime(2026, 6, 26, 8),
      );

      expect(result, DateTime(2026, 6, 27, 10));
    });
  });
}
