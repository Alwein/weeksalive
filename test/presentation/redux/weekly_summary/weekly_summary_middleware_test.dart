import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/domain/weekly_calendar.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_state.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/test_app_state.dart';
import '../../../helpers/test_store_factory.dart';
import '../../../mocks.dart';

Future<void> _waitForMiddleware() => Future<void>.delayed(const Duration(milliseconds: 50));

void main() {
  group('WeeklySummaryMiddleware', () {
    late MockWeeklySummaryRepository weeklySummaryRepo;
    late TestStoreFactory factory;

    setUp(() {
      weeklySummaryRepo = MockWeeklySummaryRepository();
      factory = TestStoreFactory()..weeklySummaryRepository = weeklySummaryRepo;
    });

    test('CheckWeeklySummaryAction requests summary when a new week is pending', () async {
      when(() => weeklySummaryRepo.getLastCompletedWeekKey()).thenAnswer((_) async => '2020-01-06');

      final user = userFixture(createdAt: DateTime(2024, 1, 1));
      final store = factory.initializeReduxStore(
        initialAppState().copyWith(userState: UserState.success(user)),
      );

      store.dispatch(const CheckWeeklySummaryAction());
      await _waitForMiddleware();

      expect(store.state.weeklySummaryState.pendingShow, isTrue);

      store.teardown();
    });

    test('CheckWeeklySummaryAction does nothing when summary already completed for current week', () async {
      final user = userFixture(createdAt: DateTime(2024, 1, 1));
      final currentKey = WeeklyCalendar.weekKey(DateTime.now(), user.weekStartDay);

      when(() => weeklySummaryRepo.getLastCompletedWeekKey()).thenAnswer((_) async => currentKey);

      final store = factory.initializeReduxStore(
        initialAppState().copyWith(userState: UserState.success(user)),
      );

      store.dispatch(const CheckWeeklySummaryAction());
      await _waitForMiddleware();

      expect(store.state.weeklySummaryState.pendingShow, isFalse);

      store.teardown();
    });

    test('CheckWeeklySummaryAction does nothing when a notification navigation is pending', () async {
      when(() => weeklySummaryRepo.getLastCompletedWeekKey()).thenAnswer((_) async => '2020-01-06');

      final user = userFixture(createdAt: DateTime(2024, 1, 1));
      final store = factory.initializeReduxStore(
        initialAppState().copyWith(
          userState: UserState.success(user),
          pushNotificationState: initialAppState().pushNotificationState.copyWith(
            pendingNavigation: PendingNotificationTarget.weeklySummary,
          ),
        ),
      );

      store.dispatch(const CheckWeeklySummaryAction());
      await _waitForMiddleware();

      expect(store.state.weeklySummaryState.pendingShow, isFalse);

      store.teardown();
    });

    test('WeeklySummaryCompletedAction persists completion and updates week key', () async {
      final user = userFixture(createdAt: DateTime(2024, 1, 1));
      final currentKey = WeeklyCalendar.weekKey(DateTime.now(), user.weekStartDay);

      final store = factory.initializeReduxStore(
        initialAppState().copyWith(
          userState: UserState.success(user),
          weeklySummaryState: const WeeklySummaryState(pendingShow: true),
        ),
      );

      store.dispatch(const WeeklySummaryCompletedAction());
      await _waitForMiddleware();

      verify(() => weeklySummaryRepo.setLastCompletedWeekKey(currentKey)).called(1);
      expect(store.state.weeklyIntentState.currentWeekKey, currentKey);
      expect(store.state.weeklySummaryState.pendingShow, isFalse);

      store.teardown();
    });

    test('UserLoadedAction initializes first signup week without showing summary', () async {
      final now = DateTime.now();
      final user = userFixture(createdAt: now);
      final currentKey = WeeklyCalendar.weekKey(now, user.weekStartDay);

      when(() => weeklySummaryRepo.getLastCompletedWeekKey()).thenAnswer((_) async => null);

      final store = factory.initializeReduxStore(initialAppState());

      store.dispatch(UserLoadedAction(user));
      await _waitForMiddleware();

      verify(() => weeklySummaryRepo.setLastCompletedWeekKey(currentKey)).called(1);
      expect(store.state.weeklySummaryState.pendingShow, isFalse);

      store.teardown();
    });
  });
}
