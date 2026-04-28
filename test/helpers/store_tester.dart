import 'package:flutter_test/flutter_test.dart';
import 'package:redux/src/store.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

import 'matchers.dart';
import 'stream_matcher_helpers.dart';

class StoreTester {
  late Store<AppState> givenStore;
  late Function() _whenFunction;

  /////////////////////////////
  // - When

  void whenDispatching(dynamic Function() action) {
    _whenFunction = () async => await givenStore.dispatch(action());
  }

  void whenDispatchingAll(List<dynamic Function()> actions) {
    _whenFunction = () async {
      for (final action in actions) {
        await givenStore.dispatch(action());
      }
    };
  }

  void when(Function() fn) {
    _whenFunction = fn;
  }

  /////////////////////////////
  // - Then

  Future<void> thenExpectChangingStatesThroughOrder(List<Matcher> matchers) async {
    expect(givenStore.onChange, emitsInOrder(matchers.map((matcher) => emitsThrough(matcher))));
    await _whenFunction();
    givenStore.teardown();
  }

  Future<void> thenExpectAtSomePoint(Matcher matcher) async {
    expect(givenStore.onChange, emitsAtLeastOnce(matcher));
    await _whenFunction();
    givenStore.teardown();
  }

  Future<void> thenExpectNever(Matcher matcher) async {
    expect(givenStore.onChange, neverEmits(matcher));
    await _whenFunction();
    givenStore.teardown();
  }

  Future<void> thenExpectNothing() async {
    await _whenFunction();
    givenStore.teardown();
  }

  Future<void> thenDebugStates(dynamic Function(AppState) info) async {
    expect(givenStore.onChange, emitsThrough(DebugMatcher(info)));
    await _whenFunction();
    givenStore.teardown();
  }

  Future<void> then(Function() expect) async {
    await _whenFunction();
    expect();
    givenStore.teardown();
  }
}
