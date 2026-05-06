import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/data/purchases/purchase_repository.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/theme/theme_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';

import 'fixtures/user_fixtures.dart';

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    when(() => getUser()).thenAnswer((_) async => userFixture());
  }
}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {}

class MockPushNotificationRepository extends Mock implements PushNotificationRepository {}

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

class MockThemeRepository extends Mock implements ThemeRepository {
  MockThemeRepository() {
    when(() => getThemeMode()).thenAnswer((_) async => ThemeMode.system);
  }
}
