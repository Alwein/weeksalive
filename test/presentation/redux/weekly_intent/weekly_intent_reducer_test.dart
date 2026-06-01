import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_reducer.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';

void main() {
  group('weeklyIntentReducer', () {
    late WeeklyIntent intentA;
    late WeeklyIntent intentB;
    late WeeklyIntent intentC;
    late WeeklyIntent intentD;
    late WeeklyIntentState baseState;

    setUp(() {
      intentA = const WeeklyIntent(id: 'a', label: 'EXPLORE');
      intentB = const WeeklyIntent(id: 'b', label: 'REST');
      intentC = const WeeklyIntent(id: 'c', label: 'CREATE');
      intentD = const WeeklyIntent(id: 'd', label: 'CONNECT');
      baseState = WeeklyIntentState(
        availableIntents: [intentA, intentB, intentC, intentD],
        selectedIds: [],
        currentWeekKey: '',
      );
    });

    group('WeeklyIntentLoadedAction', () {
      test('replaces the state with the loaded state', () {
        final loaded = WeeklyIntentState(
          availableIntents: [intentA, intentB],
          selectedIds: ['a'],
          currentWeekKey: '2026-W21',
        );

        final result = weeklyIntentReducer(baseState, WeeklyIntentLoadedAction(loaded));

        expect(result.availableIntents, [intentA, intentB]);
        expect(result.selectedIds, ['a']);
        expect(result.currentWeekKey, '2026-W21');
      });
    });

    group('SetWeeklyIntentSelectionAction', () {
      test('sets the selection', () {
        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['a']),
        );

        expect(result.selectedIds, ['a']);
      });

      test('replaces the current selection', () {
        final state = baseState.copyWith(selectedIds: ['a', 'b']);

        final result = weeklyIntentReducer(
          state,
          const SetWeeklyIntentSelectionAction(['c']),
        );

        expect(result.selectedIds, ['c']);
      });

      test('clears the selection', () {
        final state = baseState.copyWith(selectedIds: ['a', 'b']);

        final result = weeklyIntentReducer(
          state,
          const SetWeeklyIntentSelectionAction([]),
        );

        expect(result.selectedIds, isEmpty);
      });

      test('ignores unknown intent ids', () {
        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['a', 'unknown']),
        );

        expect(result.selectedIds, ['a']);
      });

      test('caps selection at 3 intents', () {
        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['a', 'b', 'c', 'd']),
        );

        expect(result.selectedIds.length, 3);
        expect(result.selectedIds, ['a', 'b', 'c']);
      });

      test('updates lastSelectedAt for newly selected intents', () {
        final before = DateTime.now().subtract(const Duration(seconds: 1));

        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['a']),
        );

        final updated = result.availableIntents.firstWhere((i) => i.id == 'a');
        expect(updated.lastSelectedAt, isNotNull);
        expect(updated.lastSelectedAt!.isAfter(before), isTrue);
      });

      test('does not update lastSelectedAt for already selected intents', () {
        final selectedAt = DateTime(2026, 5, 1);
        final intentWithDate = intentA.copyWith(lastSelectedAt: selectedAt);
        final state = WeeklyIntentState(
          availableIntents: [intentWithDate, intentB],
          selectedIds: ['a'],
          currentWeekKey: '',
        );

        final result = weeklyIntentReducer(
          state,
          const SetWeeklyIntentSelectionAction(['a']),
        );

        final updated = result.availableIntents.firstWhere((i) => i.id == 'a');
        expect(updated.lastSelectedAt, selectedAt);
      });

      test('sorts intents by lastSelectedAt descending after selection', () {
        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['c']),
        );

        expect(result.availableIntents.first.id, 'c');
      });

      test('selects multiple intents in one action', () {
        final result = weeklyIntentReducer(
          baseState,
          const SetWeeklyIntentSelectionAction(['a', 'b']),
        );

        expect(result.selectedIds, ['a', 'b']);
      });
    });

    group('AddWeeklyIntentAction', () {
      test('adds a new intent at the top of the list', () {
        final result = weeklyIntentReducer(baseState, const AddWeeklyIntentAction('OBSERVE'));

        expect(result.availableIntents.first.label, 'OBSERVE');
        expect(result.availableIntents.length, baseState.availableIntents.length + 1);
      });

      test('trims the label', () {
        final result = weeklyIntentReducer(baseState, const AddWeeklyIntentAction('  be present  '));

        expect(result.availableIntents.first.label, 'be present');
      });

      test('generates a unique id for the new intent', () {
        final result = weeklyIntentReducer(baseState, const AddWeeklyIntentAction('LEARN'));

        final ids = result.availableIntents.map((i) => i.id).toSet();
        expect(ids.length, result.availableIntents.length);
      });

      test('ignores blank labels', () {
        final result = weeklyIntentReducer(baseState, const AddWeeklyIntentAction('   '));

        expect(result.availableIntents.length, baseState.availableIntents.length);
      });
    });

    group('RemoveWeeklyIntentAction', () {
      test('removes the intent from the available list', () {
        final result = weeklyIntentReducer(baseState, const RemoveWeeklyIntentAction('b'));

        expect(result.availableIntents.map((i) => i.id), isNot(contains('b')));
      });

      test('also deselects the intent if it was selected', () {
        final state = baseState.copyWith(selectedIds: ['a', 'b']);

        final result = weeklyIntentReducer(state, const RemoveWeeklyIntentAction('b'));

        expect(result.selectedIds, isNot(contains('b')));
        expect(result.selectedIds, contains('a'));
      });
    });

    group('SetWeekKeyAction', () {
      test('updates the currentWeekKey', () {
        final result = weeklyIntentReducer(baseState, const SetWeekKeyAction('2026-W22'));

        expect(result.currentWeekKey, '2026-W22');
      });
    });

    test('returns unchanged state for unknown actions', () {
      final result = weeklyIntentReducer(baseState, Object());

      expect(result, same(baseState));
    });
  });
}
