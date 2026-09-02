import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_page.dart';

class PushNotificationNavigationHandler extends StatefulWidget {
  const PushNotificationNavigationHandler({
    super.key,
    required this.navigatorKey,
    required this.pushNotificationRepository,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final PushNotificationRepository pushNotificationRepository;
  final Widget child;

  @override
  State<PushNotificationNavigationHandler> createState() => _PushNotificationNavigationHandlerState();
}

class _PushNotificationNavigationHandlerState extends State<PushNotificationNavigationHandler> {
  bool _checkedLaunchDetails = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLaunchDetails());
  }

  Future<void> _checkLaunchDetails() async {
    if (_checkedLaunchDetails || !mounted) return;
    _checkedLaunchDetails = true;

    final launchDetails = await widget.pushNotificationRepository.getNotificationAppLaunchDetails();
    final launchPayload = launchDetails?.notificationResponse?.payload;
    if (!mounted ||
        launchDetails == null ||
        !launchDetails.didNotificationLaunchApp ||
        launchPayload == null ||
        !NotificationPayloads.isKnown(launchPayload)) {
      return;
    }

    StoreProvider.of<AppState>(context).dispatch(NotificationTappedAction(launchPayload));
  }

  Future<void> _handlePendingNavigation(Store<AppState> store, PendingNotificationTarget target) async {
    final navigatorContext = widget.navigatorKey.currentContext;
    if (navigatorContext == null) return;

    store.dispatch(const ClearNotificationTapAction());
    switch (target) {
      case PendingNotificationTarget.dayForm:
        final result = await DayForm.showBottomSheet(navigatorContext, DateTime.now(), source: 'notification');
        if (result != null) {
          await Future<void>.delayed(const Duration(seconds: 1));
          store.dispatch(const TryReviewPromptAction(source: 'notification'));
        }
      case PendingNotificationTarget.dayFormFollowup:
        final followupResult = await DayForm.showBottomSheet(
          navigatorContext,
          DateTime.now(),
          source: 'notification_followup',
        );
        if (followupResult != null) {
          await Future<void>.delayed(const Duration(seconds: 1));
          store.dispatch(const TryReviewPromptAction(source: 'notification_followup'));
        }
      case PendingNotificationTarget.yesterdayDayForm:
        final yesterday = normalizeDay(DateTime.now()).subtract(const Duration(days: 1));
        await DayForm.showBottomSheet(navigatorContext, yesterday, source: 'notification_streak_save');
      case PendingNotificationTarget.weeklySummary:
        _showWeeklySummary(store, navigatorContext);
      case PendingNotificationTarget.none:
        break;
    }
  }

  void _showWeeklySummary(Store<AppState> store, BuildContext navigatorContext) {
    store.dispatch(const ClearWeeklySummaryRequestAction());
    WeeklySummaryPage.show(
      navigatorContext,
      onDismissed: () => store.dispatch(const WeeklySummaryCompletedAction()),
    );
  }

  void _schedulePendingNavigation(Store<AppState> store, PendingNotificationTarget target) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handlePendingNavigation(store, target);
    });
  }

  void _handlePendingWeeklySummary(Store<AppState> store, bool pendingShow) {
    if (!pendingShow && (1 == 1)) return;
    if (store.state.pushNotificationState.pendingNavigation != PendingNotificationTarget.none) {
      return;
    }

    final navigatorContext = widget.navigatorKey.currentContext;
    if (navigatorContext == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showWeeklySummary(store, navigatorContext);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _StartupModalViewModel>(
      converter: _StartupModalViewModel.fromStore,
      onInitialBuild: (viewModel) {
        final store = StoreProvider.of<AppState>(context);
        if (viewModel.pendingNavigation != PendingNotificationTarget.none) {
          _schedulePendingNavigation(store, viewModel.pendingNavigation);
        } else if (viewModel.pendingWeeklySummary) {
          _handlePendingWeeklySummary(store, true);
        }
      },
      onWillChange: (previous, next) {
        final store = StoreProvider.of<AppState>(context);
        if (next.pendingNavigation != PendingNotificationTarget.none &&
            previous?.pendingNavigation == PendingNotificationTarget.none) {
          _schedulePendingNavigation(store, next.pendingNavigation);
        } else if (next.pendingWeeklySummary &&
            previous?.pendingWeeklySummary != true &&
            next.pendingNavigation == PendingNotificationTarget.none) {
          _handlePendingWeeklySummary(store, true);
        }
      },
      builder: (context, _) => widget.child,
    );
  }
}

class _StartupModalViewModel {
  const _StartupModalViewModel({
    required this.pendingNavigation,
    required this.pendingWeeklySummary,
  });

  final PendingNotificationTarget pendingNavigation;
  final bool pendingWeeklySummary;

  static _StartupModalViewModel fromStore(Store<AppState> store) {
    return _StartupModalViewModel(
      pendingNavigation: store.state.pushNotificationState.pendingNavigation,
      pendingWeeklySummary: store.state.weeklySummaryState.pendingShow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StartupModalViewModel &&
          other.pendingNavigation == pendingNavigation &&
          other.pendingWeeklySummary == pendingWeeklySummary;

  @override
  int get hashCode => Object.hash(pendingNavigation, pendingWeeklySummary);
}
