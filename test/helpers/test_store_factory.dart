import 'package:redux/redux.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

import '../mocks.dart';

class TestStoreFactory {
  RemoteConfigRepository remoteConfigRepository = MockRemoteConfigRepository();
  UserRepository userRepository = MockUserRepository();

  Store<AppState> initializeReduxStore(AppState initialState) {
    return StoreFactory(
      remoteConfigRepository: remoteConfigRepository,
      userRepository: userRepository,
    ).createStore();
  }
}
