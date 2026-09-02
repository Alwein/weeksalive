import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

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

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: [const TimeOfDay(hour: 8, minute: 0)],
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: any(named: 'hasTodayEntry'),
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).called(greaterThanOrEqualTo(1));

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

  group('UpdateUserAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

    test('reschedules weekly summary when weekStartDay changes', () async {
      const slots = NotificationSlots(
        slot1: NotificationSlotState(time: TimeOfDay(hour: 18, minute: 0), enabled: false),
        slot2: NotificationSlotState(time: TimeOfDay(hour: 21, minute: 0), enabled: false),
        weeklySummary: NotificationSlotState(time: TimeOfDay(hour: 10, minute: 30), enabled: true),
      );
      final user = userFixture(weekStartDay: DateTime.monday);

      storeTester.givenStore(
        initialAppState().copyWith(
          userState: UserState.success(user),
          pushNotificationState: initialAppState().pushNotificationState.copyWith(slots: slots),
        ),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(
        () => UpdateUserAction(
          name: user.name,
          dateOfBirth: user.dateOfBirth,
          gender: user.gender,
          lifespan: user.lifespan,
          weekStartDay: DateTime.sunday,
        ),
      );

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
        () => const NotificationTappedAction(NotificationPayloads.weeklySummary),
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
        () => const NotificationTappedAction(NotificationPayloads.dailyReminder),
      );

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.pushNotificationState.pendingNavigation,
          PendingNotificationTarget.dayForm,
        ),
      ]);
    });

    test('sets pendingNavigation to dayFormFollowup for follow-up payload', () {
      final storeTester = StoreTester();
      storeTester.givenStore(initialAppState());

      storeTester.whenDispatching(
        () => const NotificationTappedAction(NotificationPayloads.dailyFollowup),
      );

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.pushNotificationState.pendingNavigation,
          PendingNotificationTarget.dayFormFollowup,
        ),
      ]);
    });

    test('sets pendingNavigation to yesterdayDayForm for streak-save payload', () {
      final storeTester = StoreTester();
      storeTester.givenStore(initialAppState());

      storeTester.whenDispatching(
        () => const NotificationTappedAction(NotificationPayloads.streakSave),
      );

      storeTester.thenExpectStatesInOrder([
        stateWith(
          (s) => s.pushNotificationState.pendingNavigation,
          PendingNotificationTarget.yesterdayDayForm,
        ),
      ]);
    });
  });

  group('DaysLoadedAction', () {
    late StoreTester storeTester;
    late MockPushNotificationRepository pushRepo;

    setUp(() {
      storeTester = StoreTester();
      pushRepo = MockPushNotificationRepository();
    });

    test('reschedules with hasTodayEntry when today is logged', () async {
      final today = normalizeDay(DateTime.now());
      storeTester.givenStore(
        initialAppState().copyWith(
          dayState: initialAppState().dayState.copyWith(
            entries: {today: DayEntry(date: today)},
          ),
        ),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => DaysLoadedAction([DayEntry(date: today)]));

      await storeTester.thenExpectNothing();

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: true,
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).called(1);
    });

    test('passes streak count computed from loaded days', () async {
      final today = normalizeDay(DateTime.now());
      final yesterday = today.subtract(const Duration(days: 1));
      storeTester.givenStore(
        initialAppState().copyWith(
          dayState: initialAppState().dayState.copyWith(
            entries: {
              today: DayEntry(date: today),
              yesterday: DayEntry(date: yesterday),
            },
          ),
        ),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(
        () => DaysLoadedAction([DayEntry(date: today), DayEntry(date: yesterday)]),
      );

      await storeTester.thenExpectNothing();

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: true,
          streakCount: 2,
          isYesterdayGracePeriod: false,
        ),
      ).called(1);
    });

    test('reschedules even when today is not logged', () async {
      storeTester.givenStore(
        initialAppState(),
        configure: (f) => f.pushNotificationRepository = pushRepo,
      );

      storeTester.whenDispatching(() => const DaysLoadedAction([]));

      await storeTester.thenExpectNothing();

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: false,
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).called(1);
    });
  });

  group('SaveDayAction', () {
    late MockPushNotificationRepository pushRepo;
    late TestStoreFactory factory;

    setUp(() {
      pushRepo = MockPushNotificationRepository();
      factory = TestStoreFactory()..pushNotificationRepository = pushRepo;
    });

    test('reschedules with hasTodayEntry after saving today', () async {
      final today = normalizeDay(DateTime.now());
      final store = factory.initializeReduxStore(initialAppState());

      await store.dispatch(SaveDayAction(DayEntry(date: today)));
      await _dispatchBootstrapAndWaitForMiddleware();

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: true,
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).called(1);

      store.teardown();
    });

    test('reschedules after saving yesterday so the streak save can be cancelled', () async {
      final yesterday = normalizeDay(DateTime.now()).subtract(const Duration(days: 1));
      final store = factory.initializeReduxStore(initialAppState());

      await store.dispatch(SaveDayAction(DayEntry(date: yesterday)));
      await _dispatchBootstrapAndWaitForMiddleware();

      verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: any(named: 'hasTodayEntry'),
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).called(1);

      store.teardown();
    });

    test('does not reschedule after saving an older day', () async {
      final twoDaysAgo = normalizeDay(DateTime.now()).subtract(const Duration(days: 2));
      final store = factory.initializeReduxStore(initialAppState());

      await store.dispatch(SaveDayAction(DayEntry(date: twoDaysAgo)));
      await _dispatchBootstrapAndWaitForMiddleware();

      verifyNever(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: any(named: 'hasTodayEntry'),
        ),
      );

      store.teardown();
    });

    test('re-applies reschedule when a stale run finishes after saving today', () async {
      final today = normalizeDay(DateTime.now());
      final blockedSchedule = Completer<void>();
      var scheduleCallCount = 0;

      when(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: any(named: 'hasTodayEntry'),
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).thenAnswer((_) async {
        scheduleCallCount++;
        if (scheduleCallCount == 1) {
          await blockedSchedule.future;
        }
      });

      final store = factory.initializeReduxStore(initialAppState());

      final bootstrapFuture = store.dispatch(BootstrapAction());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await store.dispatch(SaveDayAction(DayEntry(date: today)));

      blockedSchedule.complete();
      await bootstrapFuture;
      await _dispatchBootstrapAndWaitForMiddleware();

      final captured = verify(
        () => pushRepo.scheduleAllNotifications(
          dailyTimes: any(named: 'dailyTimes'),
          weeklySummary: any(named: 'weeklySummary'),
          hasTodayEntry: captureAny(named: 'hasTodayEntry'),
          streakCount: any(named: 'streakCount'),
          isYesterdayGracePeriod: any(named: 'isYesterdayGracePeriod'),
        ),
      ).captured;

      expect(captured.last, isTrue);

      store.teardown();
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
