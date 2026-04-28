import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

import 'test_store_factory.dart';

AppState initialAppState() => AppState.initial();

extension AppStateDSL on AppState {
  Store<AppState> store([Function(TestStoreFactory)? configure]) {
    final factory = TestStoreFactory();
    if (configure != null) configure(factory);
    return factory.initializeReduxStore(this);
  }
}
