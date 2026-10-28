// Day logic around the days that do not last 24 hours.
//
// `flutter test` runs in the time zone of the TZ environment variable, UTC by
// default, where clocks never change and these tests are skipped. Run them in
// a zone that does:
//
//   TZ=Europe/Paris flutter test
//   TZ=America/New_York flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/gregorian_calendar.dart';
import 'package:weeksalive/domain/notifications/daily_reminder_schedule.dart';
import 'package:weeksalive/domain/notifications/nudge_notification_schedule.dart';
import 'package:weeksalive/domain/weekly_calendar.dart';

/// The first day of [year] lasting [hours] hours in this process's time zone.
DateTime? _dayLasting(int hours, {int year = 2026}) {
  for (var day = DateTime(year); day.year == year; day = addCalendarDays(day, 1)) {
    if (addCalendarDays(day, 1).difference(day).inHours == hours) return day;
  }
  return null;
}

DayEntry _loggedOn(DateTime day) => DayEntry(
  date: day,
  averageFeeling: AverageFeeling.good,
  savedAt: DateTime(day.year, day.month, day.day, 21),
);

void main() {
  final zone = DateTime(2026).timeZoneName;

  for (final (name, hours) in [('25-hour day (clocks back)', 25), ('23-hour day (clocks forward)', 23)]) {
    final changeDay = _dayLasting(hours);
    final skip = changeDay == null ? 'no $hours-hour day in $zone; run with TZ=Europe/Paris' : false;

    group(name, () {
      // Only read inside tests, which are skipped when there is no such day.
      DateTime day(int offset) => addCalendarDays(changeDay!, offset);

      test('the streak keeps counting across it', () {
        final entries = [for (var i = -5; i <= 2; i++) _loggedOn(day(i))];

        expect(computeStreak(entries, DateTime(day(2).year, day(2).month, day(2).day, 22)), 8);
        expect(computeBestStreak(entries), 8);
      }, skip: skip);

      test('yesterday is still recorded the day after', () {
        final recorded = {for (var i = -3; i <= 0; i++) day(i)};

        expect(isYesterdayGracePeriod(recordedDays: recorded, now: day(1).add(const Duration(hours: 9))), isFalse);
      }, skip: skip);

      test('missing it opens the grace period the day after', () {
        final recorded = {for (var i = -3; i <= -1; i++) day(i)};

        expect(isYesterdayGracePeriod(recordedDays: recorded, now: day(1).add(const Duration(hours: 9))), isTrue);
      }, skip: skip);

      test('it can be caught up until the end of the next day', () {
        final windowEnd = streakEligibilityWindowEnd(day(0));

        expect((windowEnd.year, windowEnd.month, windowEnd.day), (day(1).year, day(1).month, day(1).day));
        expect(isStreakEligible(entryDate: day(0), savedAt: day(1).add(const Duration(hours: 9))), isTrue);
      }, skip: skip);

      test('the streak save on its morning targets the next morning', () {
        final saveDate = NudgeNotificationSchedule.streakSaveDate(
          streakCount: 7,
          hasTodayEntry: false,
          isYesterdayGracePeriod: false,
          weeklySummaryEnabled: false,
          weekStartDay: DateTime.monday,
          now: day(0).add(const Duration(hours: 8)),
        );

        expect(saveDate, DateTime(day(1).year, day(1).month, day(1).day, 10));
      }, skip: skip);

      test('a reminder deferred over it keeps its wall-clock time', () {
        final eveningBefore = DateTime(day(-1).year, day(-1).month, day(-1).day, 21);

        final deferred = DailyReminderSchedule.deferWhenTodayLogged(
          scheduledDate: eveningBefore,
          hasTodayEntry: true,
          now: eveningBefore.subtract(const Duration(hours: 1)),
        );

        expect(deferred, DateTime(day(0).year, day(0).month, day(0).day, 21));
      }, skip: skip);

      test('the week containing it lists seven consecutive midnights', () {
        final days = WeeklyCalendar.weekDays(day(0), day(0).weekday);

        expect(days, [for (var i = 0; i < 7; i++) day(i)]);
      }, skip: skip);

      test('it is one calendar day long', () {
        expect(calendarDaysBetween(day(0), day(1)), 1);
        expect(calendarDaysBetween(day(-1), day(2)), 3);
      }, skip: skip);
    });
  }
}
