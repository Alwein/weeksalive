import 'package:flutter/material.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/push_notifications/local_notification_client.dart';
import 'package:weeksalive/data/push_notifications/local_notification_config.dart';
import 'package:weeksalive/data/push_notifications/notification_schedule_calculator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:weeksalive/domain/notifications/daily_reminder_schedule.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/notifications/nudge_notification_schedule.dart';

class LocalNotificationScheduler {
  LocalNotificationScheduler({required LocalNotificationClient client}) : _client = client;

  final LocalNotificationClient _client;

  Future<void> reschedule({
    required List<TimeOfDay> dailyTimes,
    WeeklySummarySchedule? weeklySummary,
    bool hasTodayEntry = false,
    int streakCount = 0,
    bool isYesterdayGracePeriod = false,
  }) async {
    await _client.cancelAll();
    await _scheduleDailyReminders(dailyTimes, hasTodayEntry: hasTodayEntry);
    await _scheduleFollowUp(dailyTimes, hasTodayEntry: hasTodayEntry);
    await _scheduleStreakSave(
      hasTodayEntry: hasTodayEntry,
      streakCount: streakCount,
      isYesterdayGracePeriod: isYesterdayGracePeriod,
      weeklySummary: weeklySummary,
    );
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
      final nextOccurrence = NotificationScheduleCalculator.nextDailyOccurrence(time.hour, time.minute, now: now);
      final scheduledDate = _nextDailyReminderOccurrence(
        hour: time.hour,
        minute: time.minute,
        hasTodayEntry: hasTodayEntry,
        now: now,
      );
      final isFollowUpSlot = dailyTimes.length > 1 && i == dailyTimes.length - 1;
      final title = isFollowUpSlot ? Strings.dailyFollowupNotificationTitle : Strings.dailyNotificationTitle;
      final body = isFollowUpSlot ? Strings.dailyFollowupNotificationBody : Strings.dailyNotificationBody;
      final payload = isFollowUpSlot ? NotificationPayloads.dailyFollowup : NotificationPayloads.dailyReminder;

      final skipsToday = hasTodayEntry && _toLocalDateTime(nextOccurrence).day == now.day;
      if (skipsToday) {
        // A repeating trigger ignores the date on iOS (it matches hour/minute
        // only) and would still fire today, so schedule the next days one by one.
        for (var d = 0; d < LocalNotificationConfig.deferredDailyDays; d++) {
          final day = scheduledDate.add(Duration(days: d));
          await _client.scheduleDailyOnce(
            id:
                LocalNotificationConfig.deferredDailyNotificationIdStart +
                i * LocalNotificationConfig.deferredDailyNotificationIdStride +
                d,
            title: title,
            body: body,
            payload: payload,
            scheduledDate: _toTz(DateTime(day.year, day.month, day.day, time.hour, time.minute)),
          );
        }
        continue;
      }
      await _client.scheduleDaily(
        id: LocalNotificationConfig.dailyNotificationIdStart + i,
        title: title,
        body: body,
        payload: payload,
        scheduledDate: scheduledDate,
      );
    }
  }

  Future<void> _scheduleFollowUp(
    List<TimeOfDay> dailyTimes, {
    required bool hasTodayEntry,
  }) async {
    if (dailyTimes.length != 1) return;
    final slot = dailyTimes.single;
    final now = _toLocalDateTime(tz.TZDateTime.now(tz.local));
    final followUp = NudgeNotificationSchedule.followUpDate(
      slotHour: slot.hour,
      slotMinute: slot.minute,
      enabledDailySlotCount: 1,
      hasTodayEntry: hasTodayEntry,
      now: now,
    );
    if (followUp == null) return;

    await _client.scheduleOnce(
      id: LocalNotificationConfig.followUpNotificationId,
      title: Strings.dailyFollowupNotificationTitle,
      body: Strings.dailyFollowupNotificationBody,
      payload: NotificationPayloads.dailyFollowup,
      scheduledDate: _toTz(followUp),
    );
  }

  Future<void> _scheduleStreakSave({
    required bool hasTodayEntry,
    required int streakCount,
    required bool isYesterdayGracePeriod,
    required WeeklySummarySchedule? weeklySummary,
  }) async {
    final now = _toLocalDateTime(tz.TZDateTime.now(tz.local));
    final saveDate = NudgeNotificationSchedule.streakSaveDate(
      streakCount: streakCount,
      hasTodayEntry: hasTodayEntry,
      isYesterdayGracePeriod: isYesterdayGracePeriod,
      weeklySummaryEnabled: weeklySummary != null,
      weekStartDay: weeklySummary?.weekStartDay ?? DateTime.monday,
      now: now,
    );
    if (saveDate == null) return;

    await _client.scheduleOnce(
      id: LocalNotificationConfig.streakSaveNotificationId,
      title: Strings.streakSaveNotificationTitle,
      body: Strings.streakSaveNotificationBody(streakCount),
      payload: NotificationPayloads.streakSave,
      scheduledDate: _toTz(saveDate),
    );
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
    return _toTz(deferred);
  }

  DateTime _toLocalDateTime(tz.TZDateTime value) =>
      DateTime(value.year, value.month, value.day, value.hour, value.minute);

  tz.TZDateTime _toTz(DateTime value) =>
      tz.TZDateTime(tz.local, value.year, value.month, value.day, value.hour, value.minute);

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
