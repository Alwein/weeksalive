import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart' as day_entry;
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_state.dart';
import 'package:weeksalive/presentation/streak/streak_grace_reminder_sheet.dart';

class StreakGraceReminderListener extends StatefulWidget {
  const StreakGraceReminderListener({super.key, required this.child});

  final Widget child;

  @override
  State<StreakGraceReminderListener> createState() => _StreakGraceReminderListenerState();
}

class _StreakGraceReminderListenerState extends State<StreakGraceReminderListener> {
  bool _shown = false;

  void _tryShow(_StreakGraceReminderGate gate) {
    if (_shown || !gate.shouldShow) return;

    _shown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      StreakGraceReminderSheet.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _StreakGraceReminderGate>(
      converter: _StreakGraceReminderGate.fromStore,
      onInitialBuild: _tryShow,
      onWillChange: (previous, next) {
        if (!_shown && next.shouldShow && previous?.shouldShow != true) {
          _tryShow(next);
        }
      },
      builder: (context, _) => widget.child,
    );
  }
}

class _StreakGraceReminderGate {
  const _StreakGraceReminderGate({
    required this.isYesterdayGracePeriod,
    required this.pendingWeeklySummary,
    required this.pendingNavigation,
  });

  final bool isYesterdayGracePeriod;
  final bool pendingWeeklySummary;
  final PendingNotificationTarget pendingNavigation;

  bool get shouldShow =>
      isYesterdayGracePeriod &&
      !pendingWeeklySummary &&
      pendingNavigation == PendingNotificationTarget.none;

  static _StreakGraceReminderGate fromStore(Store<AppState> store) {
    final recordedDays = store.state.dayState.entries.keys.toSet();
    return _StreakGraceReminderGate(
      isYesterdayGracePeriod: day_entry.isYesterdayGracePeriod(
        recordedDays: recordedDays,
        now: DateTime.now(),
      ),
      pendingWeeklySummary: store.state.weeklySummaryState.pendingShow,
      pendingNavigation: store.state.pushNotificationState.pendingNavigation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StreakGraceReminderGate &&
          other.isYesterdayGracePeriod == isYesterdayGracePeriod &&
          other.pendingWeeklySummary == pendingWeeklySummary &&
          other.pendingNavigation == pendingNavigation;

  @override
  int get hashCode => Object.hash(isYesterdayGracePeriod, pendingWeeklySummary, pendingNavigation);
}
