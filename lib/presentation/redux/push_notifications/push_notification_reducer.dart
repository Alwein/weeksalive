import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';

PushNotificationState pushNotificationReducer(PushNotificationState state, dynamic action) {
  if (action is NotificationTappedAction) {
    final target = switch (action.payload) {
      PushNotificationRepository.dailyReminderPayload => PendingNotificationTarget.dayForm,
      PushNotificationRepository.weeklySummaryPayload => PendingNotificationTarget.weeklySummary,
      _ => PendingNotificationTarget.none,
    };
    return state.copyWith(pendingNavigation: target);
  }
  if (action is ClearNotificationTapAction) {
    return state.copyWith(pendingNavigation: PendingNotificationTarget.none);
  }
  if (action is PushNotificationEnabledLoadedAction) {
    return state.copyWith(pushNotificationEnabled: action.pushNotificationEnabled);
  }
  if (action is NotificationSettingsLoadedAction) {
    return state.copyWith(slots: action.slots);
  }
  if (action is PushNotificationBootstrapLoadedAction) {
    return state.copyWith(
      pushNotificationEnabled: action.pushNotificationEnabled,
      slots: action.slots,
    );
  }
  return state;
}
