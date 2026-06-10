import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:weeksalive/data/push_notifications/local_notification_config.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weeksalive/domain/notifications/notification_payloads.dart';

typedef NotificationTapCallback = void Function(String payload);

class LocalNotificationClient {
  LocalNotificationClient({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> setupTimezones() async {
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));
  }

  Future<void> initialize({NotificationTapCallback? onNotificationTap}) async {
    await _plugin.initialize(
      settings: LocalNotificationConfig.initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap == null
          ? null
          : (NotificationResponse response) {
              final payload = response.payload;
              if (NotificationPayloads.isKnown(payload)) {
                onNotificationTap(payload!);
              }
            },
    );
  }

  Future<NotificationAppLaunchDetails?> getLaunchDetails() => _plugin.getNotificationAppLaunchDetails();

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS) {
      final options = await _iosPlugin?.checkPermissions();
      return options?.isEnabled ?? false;
    }
    if (Platform.isAndroid) {
      return await _androidPlugin?.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS) {
      return await _iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String payload,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: scheduledDate,
      notificationDetails: LocalNotificationConfig.dailyNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String payload,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: scheduledDate,
      notificationDetails: LocalNotificationConfig.weeklyNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  IOSFlutterLocalNotificationsPlugin? get _iosPlugin =>
      _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
}
