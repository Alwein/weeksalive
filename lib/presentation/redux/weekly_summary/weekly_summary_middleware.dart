import 'package:redux/redux.dart';
import 'package:weeksalive/data/weekly_summary/weekly_summary_repository.dart';
import 'package:weeksalive/domain/weekly_calendar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';

class WeeklySummaryMiddleware extends MiddlewareClass<AppState> {
  WeeklySummaryMiddleware({required WeeklySummaryRepository weeklySummaryRepository})
    : _weeklySummaryRepository = weeklySummaryRepository;

  final WeeklySummaryRepository _weeklySummaryRepository;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is UserLoadedAction) {
      await _initializeFirstWeekIfNeeded(store, action);
    }

    if (action is CheckWeeklySummaryAction) {
      await _checkWeeklySummary(store);
    }

    if (action is WeeklySummaryCompletedAction) {
      await _completeWeeklySummary(store);
    }
  }

  Future<void> _initializeFirstWeekIfNeeded(Store<AppState> store, UserLoadedAction action) async {
    final user = action.user;
    if (user == null) return;

    final lastCompleted = await _weeklySummaryRepository.getLastCompletedWeekKey();
    if (lastCompleted != null) return;

    final now = DateTime.now();
    final currentKey = WeeklyCalendar.weekKey(now, user.weekStartDay);
    final firstWeekKey = WeeklyCalendar.weekKey(user.createdAt, user.weekStartDay);

    if (currentKey == firstWeekKey) {
      await _weeklySummaryRepository.setLastCompletedWeekKey(currentKey);
    }
  }

  Future<void> _checkWeeklySummary(Store<AppState> store) async {
    final user = store.state.userState.userOrNull;
    if (user == null) return;

    if (store.state.pushNotificationState.pendingNavigation != PendingNotificationTarget.none) {
      return;
    }

    final lastCompleted = await _weeklySummaryRepository.getLastCompletedWeekKey();
    final now = DateTime.now();

    final shouldShow = WeeklyCalendar.shouldShowWeeklySummary(
      now: now,
      weekStartDay: user.weekStartDay,
      userCreatedAt: user.createdAt,
      lastCompletedWeekKey: lastCompleted,
    );

    if (shouldShow) {
      store.dispatch(const RequestWeeklySummaryAction());
    }
  }

  Future<void> _completeWeeklySummary(Store<AppState> store) async {
    final user = store.state.userState.userOrNull;
    if (user == null) return;

    final now = DateTime.now();
    final currentKey = WeeklyCalendar.weekKey(now, user.weekStartDay);

    await _weeklySummaryRepository.setLastCompletedWeekKey(currentKey);
    store.dispatch(SetWeekKeyAction(currentKey));
  }
}
