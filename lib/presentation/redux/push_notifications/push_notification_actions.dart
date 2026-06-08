class RequestNotificationPermissionAction {
  const RequestNotificationPermissionAction();
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
