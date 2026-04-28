import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

import 'test_store_factory.dart';

AppState initialAppState() => AppState.initial();

extension AppStateDSL on AppState {
  // find better name for foo
  Store<AppState> store([Function(TestStoreFactory)? foo]) {
    final factory = TestStoreFactory();
    if (foo != null) foo(factory);
    return factory.initializeReduxStore(this);
  }
}
