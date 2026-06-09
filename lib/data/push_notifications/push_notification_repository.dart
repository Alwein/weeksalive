import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';

class PushNotificationRepository {
  PushNotificationRepository({SharedPreferences? preferences}) : _preferences = preferences;

  final SharedPreferences? _preferences;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _dailyChannelId = 'weeksalive_daily';
  static const _weeklyChannelId = 'weeksalive_weekly';
  static const _notificationSlotsKey = 'notification_slots';
  static const _dailyChannelName = 'Daily reminders';
  static const _weeklyChannelName = 'Weekly recap';
  static const dailyReminderPayload = 'daily_reminder';
  static const weeklySummaryPayload = 'weekly_summary';
  static const _weeklyNotificationId = 10;

  Future<void> initialize({void Function(String payload)? onNotificationTap}) async {
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onNotificationTap != null
          ? (NotificationResponse response) {
              final payload = response.payload;
              if (payload == dailyReminderPayload || payload == weeklySummaryPayload) {
                onNotificationTap(payload!);
              }
            }
          : null,
    );
  }

  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() => _plugin.getNotificationAppLaunchDetails();

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS) {
      final options = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return options?.isEnabled ?? false;
    }
    if (Platform.isAndroid) {
      final bool? result = await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return result ?? false;
    }
    return true;
  }

  Future<NotificationSlots> getNotificationSlots() async {
    final json = _preferences?.getString(_notificationSlotsKey);
    if (json == null) return NotificationSlots.defaults();
    return NotificationSlots.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> setNotificationSlots(NotificationSlots slots) async {
    await _preferences?.setString(_notificationSlotsKey, jsonEncode(slots.toJson()));
  }

  Future<void> clearNotificationSlots() async {
    await _preferences?.remove(_notificationSlotsKey);
  }

  Future<void> openAppSettings() => AppSettings.openAppSettings();

  Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS) {
      final bool? result = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  Future<void> scheduleAllNotifications({
    required List<TimeOfDay> dailyTimes,
    WeeklySummarySchedule? weeklySummary,
  }) async {
    await _plugin.cancelAll();

    for (int i = 0; i < dailyTimes.length; i++) {
      final time = dailyTimes[i];
      final scheduledDate = _nextInstanceOf(time.hour, time.minute);

      await _plugin.zonedSchedule(
        id: i,
        title: Strings.dailyNotificationTitle,
        body: Strings.dailyNotificationBody,
        payload: dailyReminderPayload,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _dailyChannelId,
            _dailyChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    if (weeklySummary != null) {
      final time = weeklySummary.time;
      final scheduledDate = _nextInstanceOfWeekday(
        weeklySummary.weekStartDay,
        time.hour,
        time.minute,
      );

      await _plugin.zonedSchedule(
        id: _weeklyNotificationId,
        title: Strings.weeklySummaryNotificationTitle,
        body: Strings.weeklySummaryNotificationBody,
        payload: weeklySummaryPayload,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _weeklyChannelId,
            _weeklyChannelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
      scheduled = tz.TZDateTime(
        tz.local,
        scheduled.year,
        scheduled.month,
        scheduled.day,
        hour,
        minute,
      );
    }
    return scheduled;
  }
}
