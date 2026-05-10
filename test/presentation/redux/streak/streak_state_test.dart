import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/streak/streak_actions.dart';

import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('streak state', () {
    late StoreTester storeTester;
    late MockStreakRepository repository;

    setUp(() {
      storeTester = StoreTester();
      repository = MockStreakRepository();
    });

    group('when bootstrapping the app', () {
      test('should load streak count from repository', () {
        // Given
        when(() => repository.getStreakCount()).thenAnswer((_) async => 5);
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.streakRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith((s) => s.streakState.count, 5),
        ]);
      });

      test('should default to 0 when no streak is stored', () {
        // Given
        when(() => repository.getStreakCount()).thenAnswer((_) async => 0);
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.streakRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith((s) => s.streakState.count, 0),
        ]);
      });
    });

    group('when setting streak count', () {
      test('should persist and update the count', () {
        // Given
        when(() => repository.setStreakCount(any())).thenAnswer((_) async {});
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.streakRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => SetStreakCountAction(3));

        // Then
        storeTester.thenExpectStatesInOrder([
          stateWith((s) => s.streakState.count, 3),
        ]);
      });

      test('should persist the new count to the repository', () async {
        // Given
        when(() => repository.setStreakCount(any())).thenAnswer((_) async {});
        storeTester.givenStore(
          initialAppState(),
          configure: (f) {
            f.streakRepository = repository;
          },
        );

        // When
        storeTester.whenDispatching(() => SetStreakCountAction(7));

        // Then
        await storeTester.thenExpectAtSomePoint(
          stateWith((s) => s.streakState.count, 7),
        );
        verify(() => repository.setStreakCount(7)).called(1);
      });
    });
  });
}
