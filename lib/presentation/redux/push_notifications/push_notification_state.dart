import 'package:weeksalive/domain/notifications/notification_slots.dart';

enum PendingNotificationTarget {
  none,
  dayForm,
  dayFormFollowup,
  yesterdayDayForm,
  weeklySummary,
}

class PushNotificationState {
  PushNotificationState({
    this.pendingNavigation = PendingNotificationTarget.none,
    this.pushNotificationEnabled = false,
    NotificationSlots? slots,
  }) : slots = slots ?? NotificationSlots.defaults();

  final PendingNotificationTarget pendingNavigation;
  final bool pushNotificationEnabled;
  final NotificationSlots slots;

  PushNotificationState copyWith({
    PendingNotificationTarget? pendingNavigation,
    bool? pushNotificationEnabled,
    NotificationSlots? slots,
  }) {
    return PushNotificationState(
      pendingNavigation: pendingNavigation ?? this.pendingNavigation,
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
      slots: slots ?? this.slots,
    );
  }
}
