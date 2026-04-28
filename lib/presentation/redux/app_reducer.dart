import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/remote_config/remote_config_reducer.dart';
import 'package:weeksalive/presentation/redux/user/user_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    remoteConfigState: remoteConfigReducer(state.remoteConfigState, action),
    userState: userReducer(state.userState, action),
  );
}
