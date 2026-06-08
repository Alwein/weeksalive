import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';

class PushNotificationMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationRepository pushNotificationRepository;

  PushNotificationMiddleware({required this.pushNotificationRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final pushNotificationEnabled = await pushNotificationRepository.areNotificationsEnabled();
      store.dispatch(PushNotificationEnabledLoadedAction(pushNotificationEnabled));
    }

    if (action is RequestNotificationPermissionAction) {
      final pushNotificationEnabled = await pushNotificationRepository.requestNotificationPermission();
      store.dispatch(PushNotificationEnabledLoadedAction(pushNotificationEnabled));
    }

    if (action is SetUserAction) {
      await pushNotificationRepository.scheduleNotifications(action.user.notificationTimes);
    }
  }
}
