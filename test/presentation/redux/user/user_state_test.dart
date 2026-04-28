import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('user state', () {
    final storeTester = StoreTester();
    final repository = MockUserRepository();

    test('userState should be typed correctly', () {
      expect(const UserState.loading(), isA<UserStateLoading>());
      expect(const UserState.success(null), isA<UserStateSuccess>());
      expect(const UserState.error('error'), isA<UserStateError>());
    });

    group('when bootstraping the app', () {
      test('should load then succeed when user is not found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => null);
        storeTester.givenStore = initialAppState().store((factory) => {factory.userRepository = repository});

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectChangingStatesThroughOrder([
          stateWith((s) => s.userState, isA<UserStateLoading>()),
          stateWith((s) => s.userState, isA<UserStateSuccess>().where((s) => s.user, isNull)),
        ]);
      });

      test('should load then succeed when user is found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => userFixture());
        storeTester.givenStore = initialAppState().store((factory) => {factory.userRepository = repository});

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectChangingStatesThroughOrder([
          stateWith((s) => s.userState, isA<UserStateLoading>()),
          stateWith((s) => s.userState, isA<UserStateSuccess>().where((s) => s.user, userFixture())),
        ]);
      });
    });
  });
}
