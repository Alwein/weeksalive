import 'package:weeksalive/domain/notifications/notification_slots.dart';

class RequestNotificationPermissionAction {
  const RequestNotificationPermissionAction();
}

class NotificationSettingsLoadedAction {
  final NotificationSlots slots;
  const NotificationSettingsLoadedAction(this.slots);
}

class PushNotificationBootstrapLoadedAction {
  final bool pushNotificationEnabled;
  final NotificationSlots slots;

  const PushNotificationBootstrapLoadedAction({
    required this.pushNotificationEnabled,
    required this.slots,
  });
}

class UpdateNotificationSettingsAction {
  final NotificationSlots slots;
  const UpdateNotificationSettingsAction(this.slots);
}

class PushNotificationEnabledLoadedAction {
  final bool pushNotificationEnabled;
  const PushNotificationEnabledLoadedAction(this.pushNotificationEnabled);
}

class NotificationTappedAction {
  const NotificationTappedAction();
}

class ClearNotificationTapAction {
  const ClearNotificationTapAction();
}

class OpenNotificationSettingsAction {
  const OpenNotificationSettingsAction();
}

class RefreshNotificationPermissionAction {
  const RefreshNotificationPermissionAction();
}
