import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/data/push_notifications/local_notification_config.dart';

void main() {
  group('LocalNotificationConfig.androidScheduleMode', () {
    test('uses exact alarms when the OS allows them', () {
      expect(
        LocalNotificationConfig.androidScheduleMode(canScheduleExact: true),
        AndroidScheduleMode.exactAllowWhileIdle,
      );
    });

    test('falls back to inexact alarms when exact scheduling is denied', () {
      expect(
        LocalNotificationConfig.androidScheduleMode(canScheduleExact: false),
        AndroidScheduleMode.inexactAllowWhileIdle,
      );
    });
  });
}
