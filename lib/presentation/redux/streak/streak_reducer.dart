import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_state.dart';

StreakState streakReducer(StreakState state, dynamic action) {
  if (action is StreakCountLoadedAction) {
    return state.copyWith(count: action.count);
  }
  return state;
}
