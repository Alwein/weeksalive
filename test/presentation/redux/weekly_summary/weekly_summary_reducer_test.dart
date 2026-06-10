import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_reducer.dart';
import 'package:weeksalive/presentation/redux/weekly_summary/weekly_summary_state.dart';

void main() {
  group('weeklySummaryReducer', () {
    const baseState = WeeklySummaryState();

    test('RequestWeeklySummaryAction sets pendingShow to true', () {
      final result = weeklySummaryReducer(baseState, const RequestWeeklySummaryAction());

      expect(result.pendingShow, isTrue);
    });

    test('ClearWeeklySummaryRequestAction sets pendingShow to false', () {
      const state = WeeklySummaryState(pendingShow: true);
      final result = weeklySummaryReducer(state, const ClearWeeklySummaryRequestAction());

      expect(result.pendingShow, isFalse);
    });

    test('WeeklySummaryCompletedAction sets pendingShow to false', () {
      const state = WeeklySummaryState(pendingShow: true);
      final result = weeklySummaryReducer(state, const WeeklySummaryCompletedAction());

      expect(result.pendingShow, isFalse);
    });
  });
}
