import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_reducer.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../../fixtures/user_fixtures.dart';

void main() {
  group('userReducer', () {
    test('returns UserState.success(user) on UserLoadedAction with a user', () {
      const initialState = UserState.loading();
      final user = userFixture();

      final newState = userReducer(initialState, UserLoadedAction(user));

      expect(newState, UserState.success(user));
    });

    test('returns UserState.success(null) on UserLoadedAction with null', () {
      const initialState = UserState.loading();

      final newState = userReducer(initialState, const UserLoadedAction(null));

      expect(newState, const UserState.success(null));
    });

    test('returns the current state for an unknown action', () {
      const initialState = UserState.loading();

      final newState = userReducer(initialState, Object());

      expect(newState, same(initialState));
    });
  });
}
