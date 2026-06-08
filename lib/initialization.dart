import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/app_purchase_config.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/presentation/redux/store.dart';

import 'firebase_options.dart';

Future<Store<AppState>> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: 'env/.env');

  await AppPurchaseConfig.initializeFromEnv(dotenv);

  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting();

  final sharedPreferences = await SharedPreferences.getInstance();
  final pushNotificationRepository = PushNotificationRepository(preferences: sharedPreferences);
  await pushNotificationRepository.initialize();

  final remoteConfig = await _remoteConfig();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final store = await initializeReduxStore(remoteConfig, pushNotificationRepository: pushNotificationRepository);

  // Re-initialize with tap callback now that the store is available.
  // This handles warm-start taps (app in background).
  await pushNotificationRepository.initialize(
    onNotificationTap: () => store.dispatch(const NotificationTappedAction()),
  );

  // Handle cold-start taps: app was launched by tapping a notification.
  final launchDetails = await pushNotificationRepository.getNotificationAppLaunchDetails();
  if (launchDetails != null &&
      launchDetails.didNotificationLaunchApp &&
      launchDetails.notificationResponse?.payload == PushNotificationRepository.dailyReminderPayload) {
    store.dispatch(const NotificationTappedAction());
  }

  return store;
}

Future<FirebaseRemoteConfig?> _remoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(fetchTimeout: const Duration(seconds: 5), minimumFetchInterval: const Duration(minutes: 5)),
  );
  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    return null;
  }
  return remoteConfig;
}
