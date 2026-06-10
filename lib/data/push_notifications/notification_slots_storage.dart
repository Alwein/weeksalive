import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';

class NotificationSlotsStorage {
  NotificationSlotsStorage({required SharedPreferences preferences}) : _preferences = preferences;

  static const _notificationSlotsKey = 'notification_slots';

  final SharedPreferences _preferences;

  Future<NotificationSlots> read() async {
    final json = _preferences.getString(_notificationSlotsKey);
    if (json == null) return NotificationSlots.defaults();

    try {
      return NotificationSlots.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } on Object {
      return NotificationSlots.defaults();
    }
  }

  Future<void> write(NotificationSlots slots) async {
    await _preferences.setString(_notificationSlotsKey, jsonEncode(slots.toJson()));
  }

  Future<void> clear() async {
    await _preferences.remove(_notificationSlotsKey);
  }
}
