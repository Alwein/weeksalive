import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/store_factory.dart';

Future<Store<AppState>> initializeReduxStore(
  FirebaseRemoteConfig? firebaseRemoteConfig,
) async {
  final crashlyticsRepository = CrashlyticsRepositoryImpl();

  final reduxStore = StoreFactory(
    remoteConfigRepository: RemoteConfigRepository(crashlyticsRepository: crashlyticsRepository),
  ).createStore();

  return reduxStore;
}
