import 'package:redux/redux.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';

class UserMiddleware extends MiddlewareClass<AppState> {
  final UserRepository userRepository;

  UserMiddleware({required this.userRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final user = await userRepository.getUser();
      store.dispatch(UserLoadedAction(user));
    }
  }
}
