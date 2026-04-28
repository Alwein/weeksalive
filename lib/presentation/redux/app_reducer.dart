import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/remote_config/remote_config_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    remoteConfigState: remoteConfigReducer(state.remoteConfigState, action),
  );
}
