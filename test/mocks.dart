import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/streak/streak_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/domain/user/user.dart';

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
    when(() => requestNotificationPermission()).thenAnswer((_) async => true);
    when(() => scheduleNotifications(any())).thenAnswer((_) async {});
  }
}

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

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
