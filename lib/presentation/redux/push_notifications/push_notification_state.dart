import 'package:weeksalive/domain/notifications/notification_slots.dart';

class PushNotificationState {
  PushNotificationState({
    this.pendingOpenDayForm = false,
    this.pushNotificationEnabled = false,
    NotificationSlots? slots,
  }) : slots = slots ?? NotificationSlots.defaults();

  final bool pendingOpenDayForm;
  final bool pushNotificationEnabled;
  final NotificationSlots slots;

  PushNotificationState copyWith({
    bool? pendingOpenDayForm,
    bool? pushNotificationEnabled,
    NotificationSlots? slots,
  }) {
    return PushNotificationState(
      pendingOpenDayForm: pendingOpenDayForm ?? this.pendingOpenDayForm,
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
      slots: slots ?? this.slots,
    );
  }
}
