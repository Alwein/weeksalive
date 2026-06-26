import 'package:flutter_test/flutter_test.dart';
import 'package:redux/src/store.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

import 'matchers.dart';
import 'stream_matcher_helpers.dart';
import 'test_store_factory.dart';

class StoreTester {
  late Store<AppState> _store;
  late Function() _whenFunction;

  /////////////////////////////
  // - Given

  void givenStore(AppState state, {void Function(TestStoreFactory)? configure}) {
    final factory = TestStoreFactory();
    if (configure != null) configure(factory);
    _store = factory.initializeReduxStore(state);
  }

  /////////////////////////////
  // - When

  void whenDispatching(dynamic Function() action) {
    _whenFunction = () async => await _store.dispatch(action());
  }

  void whenDispatchingAll(List<dynamic Function()> actions) {
    _whenFunction = () async {
      for (final action in actions) {
        await _store.dispatch(action());
      }
    };
  }

  void whenExecuting(Function() fn) {
    _whenFunction = fn;
  }

  /////////////////////////////
  // - Then

  Future<void> thenExpectStatesInOrder(List<Matcher> matchers) async {
    final pending = expectLater(
      _store.onChange,
      emitsInOrder(matchers.map((matcher) => emitsThrough(matcher))),
    );
    await _whenFunction();
    await pending;
    await pumpEventQueue();
    _store.teardown();
  }

  Future<void> thenExpectAtSomePoint(Matcher matcher) async {
    final pending = expectLater(_store.onChange, emitsAtLeastOnce(matcher));
    await _whenFunction();
    await pending;
    await pumpEventQueue();
    _store.teardown();
  }

  Future<void> thenExpectNever(Matcher matcher) async {
    final pending = expectLater(_store.onChange, neverEmits(matcher));
    await _whenFunction();
    await pumpEventQueue();
    _store.teardown();
    await pending;
  }

  Future<void> thenExpectNothing() async {
    await _whenFunction();
    await pumpEventQueue();
    _store.teardown();
  }

  Future<void> thenDebugStates(dynamic Function(AppState) info) async {
    final pending = expectLater(_store.onChange, emitsThrough(DebugMatcher(info)));
    await _whenFunction();
    await pending;
    await pumpEventQueue();
    _store.teardown();
  }

  Future<void> then(Function() expect) async {
    await _whenFunction();
    await pumpEventQueue();
    expect();
    _store.teardown();
  }
}
