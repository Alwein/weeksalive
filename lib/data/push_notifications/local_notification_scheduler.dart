import 'package:flutter/material.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/push_notifications/local_notification_client.dart';
import 'package:weeksalive/data/push_notifications/local_notification_config.dart';
import 'package:weeksalive/data/push_notifications/notification_schedule_calculator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:weeksalive/domain/notifications/daily_reminder_schedule.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';

class LocalNotificationScheduler {
  LocalNotificationScheduler({required LocalNotificationClient client}) : _client = client;

  final LocalNotificationClient _client;

  Future<void> reschedule({
    required List<TimeOfDay> dailyTimes,
    WeeklySummarySchedule? weeklySummary,
    bool hasTodayEntry = false,
  }) async {
    await _client.cancelAll();
    await _scheduleDailyReminders(dailyTimes, hasTodayEntry: hasTodayEntry);
    if (weeklySummary != null) {
      await _scheduleWeeklySummary(weeklySummary);
    }
  }

  Future<void> _scheduleDailyReminders(
    List<TimeOfDay> dailyTimes, {
    required bool hasTodayEntry,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < dailyTimes.length; i++) {
      final time = dailyTimes[i];
      final scheduledDate = _nextDailyReminderOccurrence(
        hour: time.hour,
        minute: time.minute,
        hasTodayEntry: hasTodayEntry,
        now: now,
      );
      await _client.scheduleDaily(
        id: LocalNotificationConfig.dailyNotificationIdStart + i,
        title: Strings.dailyNotificationTitle,
        body: Strings.dailyNotificationBody,
        payload: NotificationPayloads.dailyReminder,
        scheduledDate: scheduledDate,
      );
    }
  }

  tz.TZDateTime _nextDailyReminderOccurrence({
    required int hour,
    required int minute,
    required bool hasTodayEntry,
    required tz.TZDateTime now,
  }) {
    final nextOccurrence = NotificationScheduleCalculator.nextDailyOccurrence(hour, minute, now: now);
    final deferred = DailyReminderSchedule.deferWhenTodayLogged(
      scheduledDate: _toLocalDateTime(nextOccurrence),
      hasTodayEntry: hasTodayEntry,
      now: _toLocalDateTime(now),
    );
    return tz.TZDateTime(tz.local, deferred.year, deferred.month, deferred.day, deferred.hour, deferred.minute);
  }

  DateTime _toLocalDateTime(tz.TZDateTime value) =>
      DateTime(value.year, value.month, value.day, value.hour, value.minute);

  Future<void> _scheduleWeeklySummary(WeeklySummarySchedule weeklySummary) async {
    final time = weeklySummary.time;
    await _client.scheduleWeekly(
      id: LocalNotificationConfig.weeklyNotificationId,
      title: Strings.weeklySummaryNotificationTitle,
      body: Strings.weeklySummaryNotificationBody,
      payload: NotificationPayloads.weeklySummary,
      scheduledDate: NotificationScheduleCalculator.nextWeeklyOccurrence(
        weeklySummary.weekStartDay,
        time.hour,
        time.minute,
      ),
    );
  }
}
