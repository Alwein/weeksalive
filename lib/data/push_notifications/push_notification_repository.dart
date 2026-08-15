import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/push_notifications/local_notification_client.dart';
import 'package:weeksalive/data/push_notifications/local_notification_scheduler.dart';
import 'package:weeksalive/data/push_notifications/notification_slots_storage.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';

class PushNotificationRepository {
  PushNotificationRepository({
    required SharedPreferences preferences,
    LocalNotificationClient? client,
  }) : _slotsStorage = NotificationSlotsStorage(preferences: preferences),
       _client = client ?? LocalNotificationClient() {
    _scheduler = LocalNotificationScheduler(client: _client);
  }

  final NotificationSlotsStorage _slotsStorage;
  final LocalNotificationClient _client;
  late final LocalNotificationScheduler _scheduler;

  Future<void> setupTimezones() => _client.setupTimezones();

  Future<void> initialize({void Function(String payload)? onNotificationTap}) =>
      _client.initialize(onNotificationTap: onNotificationTap);

  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() => _client.getLaunchDetails();

  Future<bool> areNotificationsEnabled() => _client.areNotificationsEnabled();

  Future<bool> requestNotificationPermission() => _client.requestNotificationPermission();

  Future<void> openAppSettings() => AppSettings.openAppSettings();

  Future<NotificationSlots> getNotificationSlots() => _slotsStorage.read();

  Future<void> setNotificationSlots(NotificationSlots slots) => _slotsStorage.write(slots);

  Future<void> clearNotificationSlots() => _slotsStorage.clear();

  Future<void> scheduleAllNotifications({
    required List<TimeOfDay> dailyTimes,
    WeeklySummarySchedule? weeklySummary,
    bool hasTodayEntry = false,
    int streakCount = 0,
    bool isYesterdayGracePeriod = false,
  }) =>
      _scheduler.reschedule(
        dailyTimes: dailyTimes,
        weeklySummary: weeklySummary,
        hasTodayEntry: hasTodayEntry,
        streakCount: streakCount,
        isYesterdayGracePeriod: isYesterdayGracePeriod,
      );
}
