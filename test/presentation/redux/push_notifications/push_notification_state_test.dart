import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../helpers/test_store_factory.dart';
import '../../../mocks.dart';

const _defaultWeeklySummary = NotificationSlotState(
  time: TimeOfDay(hour: 21, minute: 0),
  enabled: false,
);

Future<void> _dispatchBootstrapAndWaitForMiddleware() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

void main() {
  group('BootstrapAction', () {
    late MockPushNotificationRepository pushRepo;
    late TestStoreFactory factory;

    setUp(() {
      pushRepo = MockPushNotificationRepository();
      factory = TestStoreFactory()..pushNotificationRepository = pushRepo;
    });

    test('loads push notification state from the repository', () async {
      when(() => pushRepo.areNotificationsEnabled()).thenAnswer((_) async => true);

      final store = factory.initializeReduxStore(initialAppState());
      await store.dispatch(BootstrapAction());
      await _dispatchBootstrapAndWaitForMiddleware();

      expect(store.state.pushNotificationState.pushNotificationEnabled, isTrue);
      expect(store.state.pushNotificationState.slots, NotificationSlots.defaults());

      store.teardown();
    });

    test('loads notification slots from the repository', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 8, minute: 0), enabled: true),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 20, minute: 30), enabled: false),
        weeklySummary: _defaultWeeklySummary,
      );
      when(() => pushRepo.getNotificationSlots()).thenAnswer((_) async => slots);

      final store = factory.initializeReduxStore(initialAppState());
      await store.dispatch(BootstrapAction());
      await _dispatchBootstrapAndWaitForMiddleware();

      expect(store.state.pushNotificationState.slots, slots);

      store.teardown();
    });

    test('schedules notifications on bootstrap', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 8, minute: 0), enabled: true),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 21, minute: 0), enabled: false),
        weeklySummary: _defaultWeeklySummary,
      );
      when(() => pushRepo.getNotificationSlots()).thenAnswer((_) async => slots);

      final store = factory.initializeReduxStore(initialAppState());
      await store.dispatch(BootstrapAction());
      await _dispatchBootstrapAndWaitForMiddleware();

      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: captureAny(named: 'dailyTimes'),
          weeklySummary: captureAny(named: 'weeklySummary'),
        ),
      ).captured;
      expect(captured[0], [const TimeOfDay(hour: 8, minute: 0)]);
      expect(captured[1], isNull);

      store.teardown();
    });
  });

  group('RequestNotificationPermissionAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

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

  group('UpdateNotificationSettingsAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

    test('persists and schedules notifications with the new slots', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 8, minute: 0), enabled: true),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 20, minute: 30), enabled: true),
        weeklySummary: NotificationSlotState(time: TimeOfDay(hour: 9, minute: 0), enabled: true),
      );

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const UpdateNotificationSettingsAction(slots));

      await storeTester.thenExpectNothing();

      verify(() => pushRepo.setNotificationSlots(slots)).called(1);
      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: captureAny(named: 'dailyTimes'),
          weeklySummary: captureAny(named: 'weeklySummary'),
        ),
      ).captured;
      expect(captured[0], slots.toNotificationTimes());
      final weekly = captured[1] as WeeklySummarySchedule;
      expect(weekly.time, const TimeOfDay(hour: 9, minute: 0));
      expect(weekly.weekStartDay, DateTime.monday);
    });

    test('updates state with the new slots', () {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 9, minute: 15), enabled: true),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 21, minute: 0), enabled: false),
        weeklySummary: _defaultWeeklySummary,
      );

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const UpdateNotificationSettingsAction(slots));

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.pushNotificationState.slots, slots),
      ]);
    });

    test('schedules with empty list when all slots are disabled', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 18, minute: 0), enabled: false),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 21, minute: 0), enabled: false),
        weeklySummary: _defaultWeeklySummary,
      );

      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const UpdateNotificationSettingsAction(slots));

      await storeTester.thenExpectNothing();

      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: captureAny(named: 'dailyTimes'),
          weeklySummary: captureAny(named: 'weeklySummary'),
        ),
      ).captured;
      expect(captured[0], isEmpty);
      expect(captured[1], isNull);
    });
  });

  group('UserLoadedAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

    test('reschedules weekly summary with user weekStartDay', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 18, minute: 0), enabled: false),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 21, minute: 0), enabled: false),
        weeklySummary: NotificationSlotState(time: TimeOfDay(hour: 10, minute: 30), enabled: true),
      );

      storeTester.givenStore(
        initialAppState().copyWith(
          pushNotificationState: initialAppState().pushNotificationState.copyWith(slots: slots),
        ),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => UserLoadedAction(userFixture(weekStartDay: DateTime.sunday)));

      await storeTester.thenExpectNothing();

      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: captureAny(named: 'dailyTimes'),
          weeklySummary: captureAny(named: 'weeklySummary'),
        ),
      ).captured;
      final weekly = captured[1] as WeeklySummarySchedule;
      expect(weekly.weekStartDay, DateTime.sunday);
      expect(weekly.time, const TimeOfDay(hour: 10, minute: 30));
    });
  });

  group('NotificationTappedAction', () {
    test('sets pendingNavigation to weeklySummary for weekly payload', () {
      final storeTester = StoreTester();
      storeTester.givenStore(initialAppState());

      storeTester.whenDispatching(
        () => const NotificationTappedAction(PushNotificationRepository.weeklySummaryPayload),
      );

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.pushNotificationState.pendingNavigation,
          PendingNotificationTarget.weeklySummary,
        ),
      ]);
    });

    test('sets pendingNavigation to dayForm for daily payload', () {
      final storeTester = StoreTester();
      storeTester.givenStore(initialAppState());

      storeTester.whenDispatching(
        () => const NotificationTappedAction(PushNotificationRepository.dailyReminderPayload),
      );

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.pushNotificationState.pendingNavigation,
          PendingNotificationTarget.dayForm,
        ),
      ]);
    });
  });

  group('ClearUserAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

    test('clears notification slots and cancels scheduled notifications', () async {
      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const ClearUserAction());

      await storeTester.thenExpectNothing();

      verify(() => pushRepo.clearNotificationSlots()).called(1);
      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: captureAny(named: 'dailyTimes'),
          weeklySummary: captureAny(named: 'weeklySummary'),
        ),
      ).captured;
      expect(captured[0], isEmpty);
      expect(captured[1], isNull);
    });

    test('resets notification slots in state', () {
      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const ClearUserAction());

      storeTester.thenExpectStatesInOrder([
        stateWith((s) => s.pushNotificationState.slots, NotificationSlots.defaults()),
      ]);
    });
  });
}
