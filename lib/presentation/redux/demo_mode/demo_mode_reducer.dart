import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_actions.dart';
import 'package:weeksalive/presentation/redux/demo_mode/demo_mode_state.dart';

DemoModeState demoModeReducer(DemoModeState state, dynamic action) {
  if (action is SetDemoModeAction) {
    return state.copyWith(enabled: action.enabled);
  }
  if (action is DemoModeLoadedAction) {
    return state.copyWith(enabled: action.enabled);
  }
  return state;
}
