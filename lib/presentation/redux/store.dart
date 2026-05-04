import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

Future<Store<AppState>> initializeReduxStore(
  FirebaseRemoteConfig? firebaseRemoteConfig,
) async {
  final crashlyticsRepository = CrashlyticsRepositoryImpl();
  final sharedPreferences = await SharedPreferences.getInstance();

  final reduxStore = StoreFactory(
    remoteConfigRepository: RemoteConfigRepository(crashlyticsRepository: crashlyticsRepository),
    userRepository: UserRepository(preferences: sharedPreferences),
    pushNotificationRepository: PushNotificationRepository(),
  ).createStore();

  return reduxStore;
}
