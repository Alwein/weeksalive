import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('user state', () {
    late StoreTester storeTester;
    late MockUserRepository repository;

    setUp(() {
      storeTester = StoreTester();
      repository = MockUserRepository();
    });

    test('userState should be typed correctly', () {
      expect(const UserState.loading(), isA<UserStateLoading>());
      expect(const UserState.success(null), isA<UserStateSuccess>());
      expect(const UserState.error('error'), isA<UserStateError>());
    });

    group('when bootstraping the app', () {
      test('should load then succeed when user is not found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => null);
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.userRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith((s) => s.userState, isA<UserStateLoading>()),
          stateWith((s) => s.userState, isA<UserStateSuccess>().where((s) => s.user, isNull)),
        ]);
      });

      test('should load then succeed when user is found', () {
        // Given
        when(() => repository.getUser()).thenAnswer((_) async => userFixture());
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.userRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith((s) => s.userState, isA<UserStateLoading>()),
          stateWith((s) => s.userState, isA<UserStateSuccess>().where((s) => s.user, userFixture())),
        ]);
      });
    });

    group('when updating the user profile', () {
      test('updates profile fields in state', () {
        // Given
        final user = userFixture();
        final state = initialAppState().copyWith(userState: UserState.success(user));
        storeTester.givenStore(
          state,
          configure: (f) => f.userRepository = repository,
        );

        const newName = 'Bob';
        final newDateOfBirth = DateTime(1985, 3, 20);
        const newGender = Gender.male;
        const newLifespan = 85;

        // When
        storeTester.whenDispatching(
          () => UpdateUserAction(
            name: newName,
            dateOfBirth: newDateOfBirth,
            gender: newGender,
            lifespan: newLifespan,
          ),
        );

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.userState,
            isA<UserStateSuccess>().having(
              (state) => state.user,
              'user',
              userFixture(
                name: newName,
                dateOfBirth: newDateOfBirth,
                gender: newGender,
                lifespan: newLifespan,
              ),
            ),
          ),
        ]);
      });

      test('persists the updated user to the repository', () async {
        // Given
        final user = userFixture();
        final state = initialAppState().copyWith(userState: UserState.success(user));
        storeTester.givenStore(
          state,
          configure: (f) => f.userRepository = repository,
        );

        const newName = 'Bob';
        final newDateOfBirth = DateTime(1985, 3, 20);
        const newGender = Gender.male;
        const newLifespan = 85;

        // When
        storeTester.whenDispatching(
          () => UpdateUserAction(
            name: newName,
            dateOfBirth: newDateOfBirth,
            gender: newGender,
            lifespan: newLifespan,
          ),
        );

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.userState.userOrNull?.name,
            newName,
          ),
        ]);

        final captured = verify(() => repository.setUser(captureAny())).captured.single as User;
        expect(captured.name, newName);
        expect(captured.dateOfBirth, newDateOfBirth);
        expect(captured.gender, newGender);
        expect(captured.lifespan, newLifespan);
        expect(captured.id, user.id);
      });

      test('does nothing when no user is loaded', () async {
        // Given
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.userRepository = repository,
        );

        // When
        storeTester.whenDispatching(
          () => UpdateUserAction(
            name: 'Bob',
            dateOfBirth: DateTime(1985, 3, 20),
            gender: Gender.male,
            lifespan: 85,
          ),
        );

        // Then
        await storeTester.thenExpectNever(
          stateWith(
            (s) => s.userState,
            isA<UserStateSuccess>().having((state) => state.user?.name, 'name', 'Bob'),
          ),
        );
        verifyNever(() => repository.setUser(any()));
      });
    });
  });
}
