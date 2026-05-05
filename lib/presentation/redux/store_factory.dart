import 'package:redux/redux.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_middleware.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_middleware.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_middleware.dart';
import 'package:weeksalive/presentation/redux/user/user_middleware.dart';

class StoreFactory {
  final RemoteConfigRepository remoteConfigRepository;
  final UserRepository userRepository;
  final PushNotificationRepository pushNotificationRepository;
  final PurchaseRepository purchaseRepository;

  StoreFactory({
    required this.remoteConfigRepository,
    required this.userRepository,
    required this.pushNotificationRepository,
    required this.purchaseRepository,
  });

  Store<AppState> createStore({AppState? initialState}) {
    return Store<AppState>(
      appReducer,
      initialState: initialState ?? AppState.initial(),
      middleware: [
        BootstrapMiddleware().call,
        UserMiddleware(userRepository: userRepository).call,
        PushNotificationMiddleware(pushNotificationRepository: pushNotificationRepository).call,
        PurchaseMiddleware(purchaseRepository: purchaseRepository).call,
      ],
    );
  }
}
