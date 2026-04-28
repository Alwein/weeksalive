import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

UserState userReducer(UserState state, dynamic action) {
  if (action is UserLoadedAction) return UserState.success(action.user);
  return state;
}
