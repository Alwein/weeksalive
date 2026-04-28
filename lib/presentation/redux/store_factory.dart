import 'package:redux/redux.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

class StoreFactory {
  final RemoteConfigRepository? remoteConfigRepository;

  StoreFactory({
    required this.remoteConfigRepository,
  });

  Store<AppState> createStore() {
    return Store<AppState>(
      appReducer,
      initialState: AppState.initial(),
    );
  }
}
