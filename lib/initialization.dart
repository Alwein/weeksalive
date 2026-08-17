import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/app_purchase_config.dart';
import 'package:weeksalive/data/analytics/analytics_initializer.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/install/install_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/presentation/redux/store.dart';

import 'firebase_options.dart';

typedef AppDependencies = ({
  Store<AppState> store,
  PushNotificationRepository pushNotificationRepository,
});

Future<AppDependencies> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final crashlyticsRepository = CrashlyticsRepositoryImpl();
  // This override persists on the device, so every launch must set it: debug
  // stays local, release re-enables collection.
  await crashlyticsRepository.setCollectionEnabled(!kDebugMode);
  installCrashlyticsErrorHandlers(crashlyticsRepository);
  await crashlyticsRepository.setCustomKey(
    'app_environment',
    kDebugMode ? 'debug' : 'production',
  );

  await dotenv.load(fileName: 'env/.env');

  final sharedPreferences = await SharedPreferences.getInstance();

  // The install id has to exist before PostHog, RevenueCat and Crashlytics
  // are identified: it is the single identity they share, and onboarding
  // runs long before a [User] is persisted.
  final installRepository = InstallRepository(preferences: sharedPreferences);
  final isFirstLaunch = installRepository.isFirstLaunch;
  final installId = await installRepository.getOrCreateInstallId();
  await crashlyticsRepository.setUserId(installId);

  final analyticsRepository = await initializeAnalytics(
    dotenv: dotenv,
    installId: installId,
    isFirstLaunch: isFirstLaunch,
    isDebugMode: kDebugMode,
  );

  final tikTokEventsRepository = TikTokEventsRepository();
  await tikTokEventsRepository.initializeFromEnv(
    dotenv,
    isDebugMode: kDebugMode,
  );

  await AppPurchaseConfig.initializeFromEnv(dotenv, appUserId: installId);

  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting();

  final pushNotificationRepository = PushNotificationRepository(
    preferences: sharedPreferences,
  );
  await pushNotificationRepository.setupTimezones();

  final remoteConfig = await _remoteConfig();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final store = await initializeReduxStore(
    remoteConfig,
    pushNotificationRepository: pushNotificationRepository,
    tikTokEventsRepository: tikTokEventsRepository,
    analyticsRepository: analyticsRepository,
    installRepository: installRepository,
    crashlyticsRepository: crashlyticsRepository,
  );

  await pushNotificationRepository.initialize(
    onNotificationTap: (payload) =>
        store.dispatch(NotificationTappedAction(payload)),
  );

  return (store: store, pushNotificationRepository: pushNotificationRepository);
}

Future<FirebaseRemoteConfig?> _remoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 5),
      minimumFetchInterval: const Duration(minutes: 5),
    ),
  );
  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    return null;
  }
  return remoteConfig;
}
