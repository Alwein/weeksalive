import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_reducer.dart';
import 'package:weeksalive/presentation/redux/remote_config/remote_config_reducer.dart';
import 'package:weeksalive/presentation/redux/streak/streak_reducer.dart';
import 'package:weeksalive/presentation/redux/theme/theme_reducer.dart';
import 'package:weeksalive/presentation/redux/user/user_reducer.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    remoteConfigState: remoteConfigReducer(state.remoteConfigState, action),
    userState: userReducer(state.userState, action),
    purchaseState: purchaseReducer(state.purchaseState, action),
    themeState: themeReducer(state.themeState, action),
    streakState: streakReducer(state.streakState, action),
    weeklyIntentState: weeklyIntentReducer(state.weeklyIntentState, action),
  );
}
