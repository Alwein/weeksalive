import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/domain/notifications/notification_payloads.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary.dart';

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

  void _handlePendingNavigation(Store<AppState> store, PendingNotificationTarget target) {
    final navigatorContext = widget.navigatorKey.currentContext;
    if (navigatorContext == null) return;

    store.dispatch(const ClearNotificationTapAction());
    switch (target) {
      case PendingNotificationTarget.dayForm:
        DayForm.showBottomSheet(navigatorContext, DateTime.now());
      case PendingNotificationTarget.weeklySummary:
        WeeklySummaryPage.show(navigatorContext);
      case PendingNotificationTarget.none:
        break;
    }
  }

  void _schedulePendingNavigation(Store<AppState> store, PendingNotificationTarget target) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handlePendingNavigation(store, target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PendingNotificationTarget>(
      converter: (store) => store.state.pushNotificationState.pendingNavigation,
      onInitialBuild: (target) {
        if (target != PendingNotificationTarget.none) {
          final store = StoreProvider.of<AppState>(context);
          _schedulePendingNavigation(store, target);
        }
      },
      onWillChange: (previous, next) {
        if (next != PendingNotificationTarget.none && previous == PendingNotificationTarget.none) {
          final store = StoreProvider.of<AppState>(context);
          _schedulePendingNavigation(store, next);
        }
      },
      builder: (context, _) => widget.child,
    );
  }
}
