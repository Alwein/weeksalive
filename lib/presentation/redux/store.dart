import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
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
    themeRepository: ThemeRepository(preferences: sharedPreferences),
    pushNotificationRepository: PushNotificationRepository(),
    purchaseRepository: PurchaseRepository(dotenv: dotenv),
    streakRepository: StreakRepository(preferences: sharedPreferences),
    weeklyIntentRepository: WeeklyIntentRepository(preferences: sharedPreferences),
  ).createStore();

  return reduxStore;
}
