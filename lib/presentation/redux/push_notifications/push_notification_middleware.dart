import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';

class PushNotificationMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationRepository pushNotificationRepository;

  PushNotificationMiddleware({required this.pushNotificationRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is RequestNotificationPermissionAction) {
      await pushNotificationRepository.requestNotificationPermission();
    }
  }
}
