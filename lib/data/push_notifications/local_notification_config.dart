import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract final class LocalNotificationConfig {
  static const dailyChannelId = 'weeksalive_daily';
  static const weeklyChannelId = 'weeksalive_weekly';
  static const dailyChannelName = 'Daily reminders';
  static const weeklyChannelName = 'Weekly recap';

  static const dailyNotificationIdStart = 0;
  static const weeklyNotificationId = 10;

  static const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher_composer_outline');

  static const iosInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  static const initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  static const dailyNotificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      dailyChannelId,
      dailyChannelName,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    ),
  );

  static const weeklyNotificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      weeklyChannelId,
      weeklyChannelName,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    ),
  );
}
