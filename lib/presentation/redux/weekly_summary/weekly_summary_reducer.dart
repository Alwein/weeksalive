import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_state.dart';

WeeklySummaryState weeklySummaryReducer(WeeklySummaryState state, dynamic action) {
  if (action is RequestWeeklySummaryAction) {
    return state.copyWith(pendingShow: true);
  }

  if (action is ClearWeeklySummaryRequestAction || action is WeeklySummaryCompletedAction) {
    return state.copyWith(pendingShow: false);
  }

  return state;
}
