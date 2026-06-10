import 'package:flutter/material.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/push_notifications/local_notification_client.dart';
import 'package:weeksalive/data/push_notifications/local_notification_config.dart';
import 'package:weeksalive/data/push_notifications/notification_schedule_calculator.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';

class LocalNotificationScheduler {
  LocalNotificationScheduler({required LocalNotificationClient client}) : _client = client;

  final LocalNotificationClient _client;

  Future<void> reschedule({
    required List<TimeOfDay> dailyTimes,
    WeeklySummarySchedule? weeklySummary,
  }) async {
    await _client.cancelAll();
    await _scheduleDailyReminders(dailyTimes);
    if (weeklySummary != null) {
      await _scheduleWeeklySummary(weeklySummary);
    }
  }

  Future<void> _scheduleDailyReminders(List<TimeOfDay> dailyTimes) async {
    for (var i = 0; i < dailyTimes.length; i++) {
      final time = dailyTimes[i];
      await _client.scheduleDaily(
        id: LocalNotificationConfig.dailyNotificationIdStart + i,
        title: Strings.dailyNotificationTitle,
        body: Strings.dailyNotificationBody,
        payload: NotificationPayloads.dailyReminder,
        scheduledDate: NotificationScheduleCalculator.nextDailyOccurrence(time.hour, time.minute),
      );
    }
  }

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
