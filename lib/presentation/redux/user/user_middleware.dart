import 'package:redux/redux.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

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

    if (action is SetUserAction) {
      await userRepository.setUser(action.user);
      store.dispatch(UserLoadedAction(action.user));
    }

    if (action is UpdateUserAction) {
      final currentUser = store.state.userState.userOrNull;
      if (currentUser == null) return;

      final updatedUser = currentUser.copyWith(
        name: action.name,
        dateOfBirth: action.dateOfBirth,
        gender: action.gender,
        lifespan: action.lifespan,
      );
      await userRepository.setUser(updatedUser);
      store.dispatch(UserLoadedAction(updatedUser));
    }

    if (action is ClearUserAction) {
      await userRepository.clearUser();
      store.dispatch(const UserLoadedAction(null));
    }
  }
}
