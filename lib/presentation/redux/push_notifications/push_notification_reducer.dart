import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';

PushNotificationState pushNotificationReducer(PushNotificationState state, dynamic action) {
  if (action is NotificationTappedAction) {
    return state.copyWith(pendingOpenDayForm: true);
  }
  if (action is ClearNotificationTapAction) {
    return state.copyWith(pendingOpenDayForm: false);
  }
  return state;
}
