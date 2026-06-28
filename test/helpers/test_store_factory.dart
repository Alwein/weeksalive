import 'package:redux/redux.dart';
import 'package:weeksalive/data/app_icon/app_icon_repository.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';
import 'package:weeksalive/data/home_widget/home_widget_service.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/rewards/rewards_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/rewards/reward_unlock_service.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

import '../mocks.dart';

class TestStoreFactory {
  RemoteConfigRepository remoteConfigRepository = MockRemoteConfigRepository();
  UserRepository userRepository = MockUserRepository();
  PushNotificationRepository pushNotificationRepository = MockPushNotificationRepository();
  PurchaseRepository purchaseRepository = MockPurchaseRepository();
  TikTokEventsRepository tikTokEventsRepository = TikTokEventsRepository();
  ThemeRepository themeRepository = MockThemeRepository();
  AppIconRepository appIconRepository = MockAppIconRepository();
  GridMotifRepository gridMotifRepository = MockGridMotifRepository();
  RewardsRepository rewardsRepository = MockRewardsRepository();
  NavigationRepository navigationRepository = MockNavigationRepository();

  /// Not wired into the test store by default to prevent async dispatch
  /// interference with other middleware bootstrap tests. Use the isolated
  /// store helper in weekly_intent_state_test.dart for bootstrap tests.
  WeeklyIntentRepository weeklyIntentRepository = MockWeeklyIntentRepository();
  WeeklySummaryRepository weeklySummaryRepository = MockWeeklySummaryRepository();
  DayRepository dayRepository = MockDayRepository();
  HomeWidgetService homeWidgetService = FakeHomeWidgetService();
  WallpaperConfigRepository wallpaperConfigRepository = MockWallpaperConfigRepository();

  Store<AppState> initializeReduxStore(AppState initialState) {
    return StoreFactory(
      remoteConfigRepository: remoteConfigRepository,
      userRepository: userRepository,
      pushNotificationRepository: pushNotificationRepository,
      purchaseRepository: purchaseRepository,
      tikTokEventsRepository: tikTokEventsRepository,
      themeRepository: themeRepository,
      appIconRepository: appIconRepository,
      gridMotifRepository: gridMotifRepository,
      rewardsRepository: rewardsRepository,
      weeklyIntentRepository: weeklyIntentRepository,
      weeklySummaryRepository: weeklySummaryRepository,
      dayRepository: dayRepository,
      navigationRepository: navigationRepository,
      rewardUnlockService: const RewardUnlockService(),
      homeWidgetService: homeWidgetService,
      wallpaperConfigRepository: wallpaperConfigRepository,
    ).createStore(initialState: initialState);
  }
}
