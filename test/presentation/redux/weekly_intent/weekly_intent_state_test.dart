import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';

import '../../../helpers/matchers.dart';
import '../../../helpers/store_tester.dart';
import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

void main() {
  group('weekly intent state', () {
    late StoreTester storeTester;
    late MockWeeklyIntentRepository repository;

    setUp(() {
      storeTester = StoreTester();
      repository = MockWeeklyIntentRepository();
    });

    group('when bootstrapping the app (isolated middleware)', () {
      test('uses default intents when nothing is stored', () async {
        // Given
        when(() => repository.getIntents()).thenAnswer((_) => Future.sync(() => null));
        when(() => repository.getSelection()).thenAnswer((_) => Future.sync(() => <String>[]));
        when(() => repository.getWeekKey()).thenAnswer((_) => Future.sync(() => null));
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.length,
            kDefaultWeeklyIntents.length,
          ),
        ]);
      });

      test('restores persisted intents and selection', () async {
        // Given
        final savedIntents = [
          const WeeklyIntent(id: 'x', label: 'EXPLORE'),
          const WeeklyIntent(id: 'y', label: 'REST'),
        ];
        when(() => repository.getIntents()).thenAnswer((_) => Future.sync(() => savedIntents));
        when(() => repository.getSelection()).thenAnswer((_) => Future.sync(() => ['x']));
        when(() => repository.getWeekKey()).thenAnswer((_) => Future.sync(() => '2026-W21'));
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents,
            savedIntents,
          ),
        ]);
      });

      test('persists defaults to repo on first launch', () async {
        // Given
        when(() => repository.getIntents()).thenAnswer((_) => Future.sync(() => null));
        when(() => repository.getSelection()).thenAnswer((_) => Future.sync(() => <String>[]));
        when(() => repository.getWeekKey()).thenAnswer((_) => Future.sync(() => null));
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => BootstrapAction());

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.length,
            kDefaultWeeklyIntents.length,
          ),
        ]);

        await Future.delayed(const Duration(milliseconds: 100), () {
          verify(() => repository.setIntents(any())).called(1);
        });
      });
    });

    group('when setting the selection', () {
      test('sets intent selection', () async {
        // Given
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        final targetId = kDefaultWeeklyIntents.first.id;

        // When
        storeTester.whenDispatching(() => SetWeeklyIntentSelectionAction([targetId]));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.selectedIds,
            [targetId],
          ),
        ]);
      });

      test('clears selection', () async {
        // Given
        final targetId = kDefaultWeeklyIntents.first.id;
        final preloaded = initialAppState().weeklyIntentState.copyWith(
          selectedIds: [targetId],
        );
        final state = initialAppState().copyWith(weeklyIntentState: preloaded);
        storeTester.givenStore(
          state,
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => const SetWeeklyIntentSelectionAction([]));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.selectedIds,
            isEmpty,
          ),
        ]);
      });

      test('persists the selection to the repository', () async {
        // Given
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        final targetId = kDefaultWeeklyIntents.first.id;

        // When
        storeTester.whenDispatching(() => SetWeeklyIntentSelectionAction([targetId]));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.selectedIds,
            [targetId],
          ),
        ]);
        verify(() => repository.setSelection(any())).called(1);
      });
    });

    group('when adding a custom intent', () {
      test('adds the intent to available list', () async {
        // Given
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => const AddWeeklyIntentAction('DREAM'));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.map((i) => i.label),
            contains('DREAM'),
          ),
        ]);
      });

      test('persists the updated list to the repository', () async {
        // Given
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => const AddWeeklyIntentAction('DREAM'));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.map((i) => i.label),
            contains('DREAM'),
          ),
        ]);
        verify(() => repository.setIntents(any())).called(1);
      });
    });

    group('when removing an intent', () {
      test('removes it from available list', () async {
        // Given
        final targetId = kDefaultWeeklyIntents.first.id;
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => RemoveWeeklyIntentAction(targetId));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.map((i) => i.id),
            isNot(contains(targetId)),
          ),
        ]);
      });

      test('persists the updated list to the repository', () async {
        // Given
        final targetId = kDefaultWeeklyIntents.first.id;
        storeTester.givenStore(
          initialAppState(),
          configure: (f) => f.weeklyIntentRepository = repository,
        );

        // When
        storeTester.whenDispatching(() => RemoveWeeklyIntentAction(targetId));

        // Then
        await storeTester.thenExpectStatesInOrder([
          stateWith(
            (s) => s.weeklyIntentState.availableIntents.map((i) => i.id),
            isNot(contains(targetId)),
          ),
        ]);
        verify(() => repository.setIntents(any())).called(1);
      });
    });
  });
}
