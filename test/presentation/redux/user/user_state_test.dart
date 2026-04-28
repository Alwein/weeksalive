import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
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
      storeTester.whenDispatchingAction(() => BootstrapAction());

      test('should load then succeed when user is not found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => null);

        // When
        storeTester.givenStore = initialAppState().store((factory) => {factory.userRepository = repository});

        // Then
        // TODO: Est-ce qu'on pourrait pas améliorer cette syntaxe ?
        storeTester.thenExpectChangingStatesThroughOrder([
          StateIs<UserStateLoading>((state) => state.userState),
          isA<AppState>().having(
            (state) => state.userState,
            'userState',
            isA<UserStateSuccess>().having((state) => state.user, 'user', isNull),
          ),
        ]);
      });

      test('should load then succeed when user is found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => userFixture());

        // When
        storeTester.givenStore = initialAppState().store((factory) => {factory.userRepository = repository});

        // Then
        storeTester.thenExpectChangingStatesThroughOrder([
          StateIs<UserStateLoading>((state) => state.userState),
          isA<AppState>().having(
            (state) => state.userState,
            'userState',
            isA<UserStateSuccess>().having((state) => state.user, 'user', userFixture()),
          ),
        ]);
      });
    });
  });
}
