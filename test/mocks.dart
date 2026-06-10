import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:weeksalive/data/day/day_repository.dart';
import 'package:weeksalive/data/navigation/navigation_repository.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/data/weekly_intent/weekly_intent_repository.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
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
    registerFallbackValue(const WeeklySummarySchedule(time: TimeOfDay(hour: 21, minute: 0), weekStartDay: DateTime.monday));
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
    when(() => getThemeMode()).thenAnswer((_) async => ThemeMode.system);
  }
}

class MockStreakRepository extends Mock implements StreakRepository {
  MockStreakRepository() {
    when(() => getStreakCount()).thenAnswer((_) async => 0);
    when(() => setStreakCount(any())).thenAnswer((_) async {});
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
