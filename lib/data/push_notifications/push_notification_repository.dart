import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationRepository {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS) {
      final bool? result = await _flutterLocalNotificationsPlugin
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
}
