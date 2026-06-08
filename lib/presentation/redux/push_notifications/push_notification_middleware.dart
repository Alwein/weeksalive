import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
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
      final results = await Future.wait([
        pushNotificationRepository.areNotificationsEnabled(),
        pushNotificationRepository.getNotificationSlots(),
      ]);
      final pushNotificationEnabled = results[0] as bool;
      final slots = results[1] as NotificationSlots;
      store.dispatch(
        PushNotificationBootstrapLoadedAction(
          pushNotificationEnabled: pushNotificationEnabled,
          slots: slots,
        ),
      );
      await pushNotificationRepository.scheduleNotifications(slots.toNotificationTimes());
    }

    if (action is RequestNotificationPermissionAction) {
      final pushNotificationEnabled = await pushNotificationRepository.requestNotificationPermission();
      store.dispatch(PushNotificationEnabledLoadedAction(pushNotificationEnabled));
    }

    if (action is UpdateNotificationSettingsAction) {
      await pushNotificationRepository.setNotificationSlots(action.slots);
      store.dispatch(NotificationSettingsLoadedAction(action.slots));
      await pushNotificationRepository.scheduleNotifications(action.slots.toNotificationTimes());
    }

    if (action is ClearUserAction) {
      await pushNotificationRepository.clearNotificationSlots();
      final defaults = NotificationSlots.defaults();
      store.dispatch(NotificationSettingsLoadedAction(defaults));
      await pushNotificationRepository.scheduleNotifications([]);
    }
  }
}
