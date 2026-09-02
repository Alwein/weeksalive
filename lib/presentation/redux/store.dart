import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeksalive/data/analytics/analytics_repository.dart';
import 'package:weeksalive/data/app_icon/app_icon_repository.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/install/install_repository.dart';
import 'package:weeksalive/data/day/app_database.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/review/review_prompt_repository.dart';
import 'package:weeksalive/data/rewards/rewards_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

Future<Store<AppState>> initializeReduxStore(
  FirebaseRemoteConfig? firebaseRemoteConfig, {
  PushNotificationRepository? pushNotificationRepository,
  TikTokEventsRepository? tikTokEventsRepository,
  AnalyticsRepository? analyticsRepository,
  InstallRepository? installRepository,
  CrashlyticsRepository? crashlyticsRepository,
}) async {
  final crashlytics = crashlyticsRepository ?? CrashlyticsRepositoryImpl();
  final sharedPreferences = await SharedPreferences.getInstance();
  final appDatabase = AppDatabase();

  final reduxStore = StoreFactory(
    remoteConfigRepository: RemoteConfigRepository(
      crashlyticsRepository: crashlytics,
    ),
    userRepository: UserRepository(preferences: sharedPreferences),
    themeRepository: ThemeRepository(preferences: sharedPreferences),
    appIconRepository: AppIconRepository(preferences: sharedPreferences),
    gridMotifRepository: GridMotifRepository(preferences: sharedPreferences),
    navigationRepository: NavigationRepository(preferences: sharedPreferences),
    pushNotificationRepository:
        pushNotificationRepository ??
        PushNotificationRepository(preferences: sharedPreferences),
    purchaseRepository: PurchaseRepository(dotenv: dotenv),
    tikTokEventsRepository: tikTokEventsRepository ?? TikTokEventsRepository(),
    rewardsRepository: RewardsRepository(preferences: sharedPreferences),
    weeklyIntentRepository: WeeklyIntentRepository(
      preferences: sharedPreferences,
    ),
    weeklySummaryRepository: WeeklySummaryRepository(
      preferences: sharedPreferences,
    ),
    dayRepository: DayRepository(database: appDatabase),
    wallpaperConfigRepository: WallpaperConfigRepository(
      preferences: sharedPreferences,
    ),
    analyticsRepository: analyticsRepository ?? const NoopAnalyticsRepository(),
    installRepository:
        installRepository ?? InstallRepository(preferences: sharedPreferences),
    reviewPromptStore: ReviewPromptRepository(preferences: sharedPreferences),
  ).createStore();

  return reduxStore;
}
