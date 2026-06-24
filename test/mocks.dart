import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/data/app_icon/app_icon_repository.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/grid_motif/grid_motif_repository.dart';
import 'package:weeksalive/data/home_widget/home_widget_service.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/rewards/rewards_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_config_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';

import 'fixtures/user_fixtures.dart';

class _FakeUser extends Fake implements User {}

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(_FakeUser());
    when(() => getUser()).thenAnswer((_) async => userFixture());
    when(() => setUser(any())).thenAnswer((_) async {});
    when(() => clearUser()).thenAnswer((_) async {});
  }
}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {}

class MockPushNotificationRepository extends Mock implements PushNotificationRepository {
  MockPushNotificationRepository() {
    registerFallbackValue(<TimeOfDay>[]);
    registerFallbackValue(NotificationSlots.defaults());
    registerFallbackValue(
      const WeeklySummarySchedule(time: TimeOfDay(hour: 21, minute: 0), weekStartDay: DateTime.monday),
    );
    when(() => areNotificationsEnabled()).thenAnswer((_) async => false);
    when(() => requestNotificationPermission()).thenAnswer((_) async => true);
    when(() => getNotificationSlots()).thenAnswer((_) async => NotificationSlots.defaults());
    when(() => setNotificationSlots(any())).thenAnswer((_) async {});
    when(() => clearNotificationSlots()).thenAnswer((_) async {});
    when(
      () => scheduleAllNotifications(
        dailyTimes: any(named: 'dailyTimes'),
        weeklySummary: any(named: 'weeklySummary'),
      ),
    ).thenAnswer((_) async {});
    when(() => openAppSettings()).thenAnswer((_) async {});
  }
}

class FakeCustomerInfo extends Fake implements CustomerInfo {}

class MockPurchaseRepository extends Mock implements PurchaseRepository {
  MockPurchaseRepository() {
    registerFallbackValue(FakeCustomerInfo());
    when(() => fetchCurrentOffering()).thenAnswer((_) => Future.sync(() => null));
    when(() => getCustomerInfo()).thenAnswer((_) => Future.sync(() => FakeCustomerInfo()));
    when(() => isPro(any())).thenReturn(false);
  }
}

class MockThemeRepository extends Mock implements ThemeRepository {
  MockThemeRepository() {
    registerFallbackValue(AppThemeId.system);
    when(() => getSelectedTheme()).thenAnswer((_) async => AppThemeId.system);
    when(() => setSelectedTheme(any())).thenAnswer((_) async {});
  }
}

class MockAppIconRepository extends Mock implements AppIconRepository {
  MockAppIconRepository() {
    registerFallbackValue(AppIconId.composer);
    when(() => getSelectedIcon()).thenAnswer((_) async => AppIconId.composer);
    when(() => setSelectedIcon(any())).thenAnswer((_) async {});
  }
}

class MockGridMotifRepository extends Mock implements GridMotifRepository {
  MockGridMotifRepository() {
    registerFallbackValue(GridMotifId.dots);
    when(() => getSelectedMotif()).thenAnswer((_) async => GridMotifId.dots);
    when(() => setSelectedMotif(any())).thenAnswer((_) async {});
  }
}

class MockRewardsRepository extends Mock implements RewardsRepository {
  MockRewardsRepository() {
    registerFallbackValue(<RewardId>{});
    when(() => getUnlocked()).thenAnswer((_) async => {});
    when(() => unlock(any())).thenAnswer((_) async {});
  }
}

class MockNavigationRepository extends Mock implements NavigationRepository {
  MockNavigationRepository() {
    when(() => getHomeTabIndex()).thenAnswer((_) async => 0);
    when(() => setHomeTabIndex(any())).thenAnswer((_) async {});
  }
}

class MockWeeklySummaryRepository extends Mock implements WeeklySummaryRepository {
  MockWeeklySummaryRepository() {
    when(() => getLastCompletedWeekKey()).thenAnswer((_) => Future.sync(() => null));
    when(() => setLastCompletedWeekKey(any())).thenAnswer((_) => Future.sync(() {}));
  }
}

class MockWeeklyIntentRepository extends Mock implements WeeklyIntentRepository {
  MockWeeklyIntentRepository() {
    registerFallbackValue(<WeeklyIntent>[]);
    registerFallbackValue(<String>[]);
    // Use Future.sync to complete in the current microtask queue, avoiding
    // async dispatch interference when the Redux store is torn down in tests.
    when(() => getIntents()).thenAnswer((_) => Future.sync(() => null));
    when(() => setIntents(any())).thenAnswer((_) => Future.sync(() {}));
    when(() => getSelection()).thenAnswer((_) => Future.sync(() => <String>[]));
    when(() => setSelection(any())).thenAnswer((_) => Future.sync(() {}));
    when(() => getWeekKey()).thenAnswer((_) => Future.sync(() => null));
    when(() => setWeekKey(any())).thenAnswer((_) => Future.sync(() {}));
  }
}

class _FakeDayEntry extends Fake implements DayEntry {}

class MockDayRepository extends Mock implements DayRepository {
  MockDayRepository() {
    registerFallbackValue(_FakeDayEntry());
    // Use Future.sync to complete in the current microtask queue, avoiding
    // async dispatch interference when the Redux store is torn down in tests.
    when(() => getAll()).thenAnswer((_) => Future.sync(() => <DayEntry>[]));
    when(() => getByDate(any())).thenAnswer((_) => Future.sync(() => null));
    when(() => upsert(any())).thenAnswer((_) => Future.sync(() {}));
  }
}

/// No-op home widget service used in tests so that no platform-channel calls
/// (and no async dispatch) happen while the Redux store is being torn down.
class FakeHomeWidgetService extends Fake implements HomeWidgetService {
  @override
  Future<void> updateAll({
    required User? user,
    required Iterable<DayEntry> entries,
    required AppThemeId selectedTheme,
  }) async {}
}

class MockWallpaperConfigRepository extends Mock implements WallpaperConfigRepository {
  MockWallpaperConfigRepository() {
    registerFallbackValue(const WallpaperConfig());
    when(() => getConfig()).thenReturn(const WallpaperConfig());
    when(() => setConfig(any())).thenAnswer((_) async {});
  }
}
