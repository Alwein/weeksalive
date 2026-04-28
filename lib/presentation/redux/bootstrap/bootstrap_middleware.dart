import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';

class BootstrapMiddleware extends MiddlewareClass<AppState> {
  bool isInitialized = false;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction && !isInitialized) {
      isInitialized = true;
    }
  }
}
