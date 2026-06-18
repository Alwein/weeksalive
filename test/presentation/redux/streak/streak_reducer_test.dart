import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_reducer.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';

void main() {
  group('streakReducer', () {
    test('updates count and bestEver on StreakRecalculatedAction', () {
      const state = StreakState(count: 1, bestEver: 5);

      final next = streakReducer(
        state,
        const StreakRecalculatedAction(count: 3, bestEver: 8),
      );

      expect(next.count, 3);
      expect(next.bestEver, 8);
    });
  });
}
