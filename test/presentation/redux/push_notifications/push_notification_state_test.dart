import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('BootstrapAction', () {
    late StoreTester storeTester;
    final pushRepo = MockPushNotificationRepository();

    setUp(() => storeTester = StoreTester());

    test('loads pushNotificationEnabled from the repository', () {
      when(() => pushRepo.areNotificationsEnabled()).thenAnswer((_) async => true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => BootstrapAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.pushNotificationState.pushNotificationEnabled, isTrue),
      ]);
    });
  });

  group('RequestNotificationPermissionAction', () {
    late StoreTester storeTester;
    final pushRepo = MockPushNotificationRepository();

    setUp(() => storeTester = StoreTester());

    test('calls requestNotificationPermission on the repository', () async {
      when(() => pushRepo.requestNotificationPermission()).thenAnswer((_) async => true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const RequestNotificationPermissionAction());

      await storeTester.thenExpectNothing();

      verify(() => pushRepo.requestNotificationPermission()).called(1);
    });

    test('updates pushNotificationEnabled when permission is granted', () {
      when(() => pushRepo.requestNotificationPermission()).thenAnswer((_) async => true);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const RequestNotificationPermissionAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.pushNotificationState.pushNotificationEnabled, isTrue),
      ]);
    });

    test('updates pushNotificationEnabled when permission is denied', () {
      when(() => pushRepo.requestNotificationPermission()).thenAnswer((_) async => false);

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const RequestNotificationPermissionAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.pushNotificationState.pushNotificationEnabled, isFalse),
      ]);
    });
  });

  group('SetUserAction — notification scheduling', () {
    late StoreTester storeTester;
    final pushRepo = MockPushNotificationRepository();

    setUp(() => storeTester = StoreTester());

    test('schedules notifications with the user notificationTimes on SetUserAction', () async {
      final times = [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 20, minute: 30)];
      final user = userFixture(notificationTimes: times);

      when(() => pushRepo.scheduleNotifications(any())).thenAnswer((_) async {});

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => SetUserAction(user));

      await storeTester.thenExpectNothing();

      final captured = verify(() => pushRepo.scheduleNotifications(captureAny())).captured.single as List<TimeOfDay>;
      expect(captured, times);
    });

    test('schedules notifications once per SetUserAction dispatch', () async {
      final user = userFixture();
      when(() => pushRepo.scheduleNotifications(any())).thenAnswer((_) async {});

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => SetUserAction(user));

      await storeTester.thenExpectNothing();

      verify(() => pushRepo.scheduleNotifications(any())).called(1);
    });

    test('reschedules with new times when SetUserAction is dispatched a second time', () async {
      final firstTimes = [const TimeOfDay(hour: 9, minute: 0)];
      final secondTimes = [const TimeOfDay(hour: 18, minute: 0), const TimeOfDay(hour: 21, minute: 0)];

      when(() => pushRepo.scheduleNotifications(any())).thenAnswer((_) async {});

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatchingAll([
        () => SetUserAction(userFixture(notificationTimes: firstTimes)),
        () => SetUserAction(userFixture(notificationTimes: secondTimes)),
      ]);

      await storeTester.thenExpectNothing();

      final calls = verify(() => pushRepo.scheduleNotifications(captureAny())).captured;
      expect(calls, hasLength(2));
      expect(calls[0], firstTimes);
      expect(calls[1], secondTimes);
    });

    test('schedules with empty list when user has no notification times', () async {
      final user = userFixture(notificationTimes: []);
      when(() => pushRepo.scheduleNotifications(any())).thenAnswer((_) async {});

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => SetUserAction(user));

      await storeTester.thenExpectNothing();

      final captured = verify(() => pushRepo.scheduleNotifications(captureAny())).captured.single as List<TimeOfDay>;
      expect(captured, isEmpty);
    });
  });
}
