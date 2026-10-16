import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // The external id is the same install id as PostHog, RevenueCat and
  // Crashlytics: it is what will let server-side Events API calls (trial
  // conversion, churn) be attributed to the user the SDK already knows. It is
  // applied when the SDK starts, which on a first launch is after the ATT step.
  //
  // Not awaited: the SDK only answers once TikTok's servers have, and where
  // they are blocked (mainland China) every launch sat on the splash screen
  // until the request timed out. Events logged before it is up are dropped,
  // as they are when it fails to start.
  unawaited(
    tikTokEventsRepository.initializeFromEnv(
      dotenv,
      isDebugMode: kDebugMode,
      isFirstLaunch: isFirstLaunch,
      externalId: installId,
    ),
  );

  await AppPurchaseConfig.initializeFromEnv(dotenv, appUserId: installId);

  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting();

  final pushNotificationRepository = PushNotificationRepository(
    preferences: sharedPreferences,
  );
  await pushNotificationRepository.setupTimezones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final store = await initializeReduxStore(
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
