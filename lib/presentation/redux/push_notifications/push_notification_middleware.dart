import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

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
      await _reschedule(store);
    }

    if (action is RequestNotificationPermissionAction) {
      final pushNotificationEnabled = await pushNotificationRepository.requestNotificationPermission();
      store.dispatch(PushNotificationEnabledLoadedAction(pushNotificationEnabled));
    }

    if (action is RefreshNotificationPermissionAction) {
      final pushNotificationEnabled = await pushNotificationRepository.areNotificationsEnabled();
      store.dispatch(PushNotificationEnabledLoadedAction(pushNotificationEnabled));
    }

    if (action is OpenNotificationSettingsAction) {
      await pushNotificationRepository.openAppSettings();
    }

    if (action is UpdateNotificationSettingsAction) {
      await pushNotificationRepository.setNotificationSlots(action.slots);
      store.dispatch(NotificationSettingsLoadedAction(action.slots));
      await _reschedule(store);
    }

    if (action is UpdateUserAction) {
      final previousWeekStartDay = store.state.userState.userOrNull?.weekStartDay;
      if (previousWeekStartDay != null && previousWeekStartDay != action.weekStartDay) {
        await _reschedule(store, weekStartDay: action.weekStartDay);
      }
    }

    if (action is UserLoadedAction) {
      await _reschedule(store);
    }

    if (action is ClearUserAction) {
      await pushNotificationRepository.clearNotificationSlots();
      final defaults = NotificationSlots.defaults();
      store.dispatch(NotificationSettingsLoadedAction(defaults));
      await pushNotificationRepository.scheduleAllNotifications(
        dailyTimes: [],
        weeklySummary: null,
      );
    }
  }

  Future<void> _reschedule(Store<AppState> store, {int? weekStartDay}) async {
    final slots = store.state.pushNotificationState.slots;
    final effectiveWeekStartDay =
        weekStartDay ?? store.state.userState.userOrNull?.weekStartDay ?? DateTime.monday;

    await pushNotificationRepository.scheduleAllNotifications(
      dailyTimes: slots.toNotificationTimes(),
      weeklySummary: slots.weeklySummarySchedule(effectiveWeekStartDay),
    );
  }
}
