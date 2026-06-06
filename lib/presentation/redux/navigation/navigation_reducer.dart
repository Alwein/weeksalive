import 'package:weeksalive/presentation/redux/navigation/navigation_actions.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_state.dart';

NavigationState navigationReducer(NavigationState state, dynamic action) {
  if (action is HomeTabIndexLoadedAction) {
    return state.copyWith(homeTabIndex: action.index);
  }
  return state;
}
