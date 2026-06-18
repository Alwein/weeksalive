import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

Store<AppState> _dayStore(
  DayMiddleware dayMiddleware, {
  AppState? initialState,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState ?? initialAppState(),
    middleware: [dayMiddleware.call],
  );
}

void main() {
  group('day state', () {
    late MockDayRepository repository;
    late DayMiddleware middleware;

    final today = DateTime.now();
    DateTime daysAgo(int n) => DateTime(today.year, today.month, today.day).subtract(Duration(days: n));

    DayEntry entryForDay(int daysBack) {
      final date = daysAgo(daysBack);
      return DayEntry(date: date, savedAt: date.add(const Duration(hours: 12)));
    }

    setUp(() {
      repository = MockDayRepository();
      middleware = DayMiddleware(dayRepository: repository);
    });

    group('when bootstrapping the app', () {
      test('loads stored days into the state', () async {
        final entries = [
          entryForDay(0),
          entryForDay(1),
        ];
        when(() => repository.getAll()).thenAnswer((_) => Future.sync(() => entries));
        final store = _dayStore(middleware);

        await store.dispatch(BootstrapAction());
        await pumpEventQueue();

        expect(store.state.dayState.entries.length, 2);
      });

      test('recomputes the streak when days are loaded', () async {
        final entries = [
          entryForDay(0),
          entryForDay(1),
        ];
        when(() => repository.getAll()).thenAnswer((_) => Future.sync(() => entries));
        final store = _dayStore(middleware);

        await store.dispatch(BootstrapAction());
        await pumpEventQueue();

        expect(store.state.streakState.count, 2);
        expect(store.state.streakState.bestEver, 2);
      });

      test('recomputes the streak when a day is later saved', () async {
        final entries = [
          entryForDay(1),
          entryForDay(2),
        ];
        when(() => repository.getAll()).thenAnswer((_) => Future.sync(() => entries));
        final store = _dayStore(middleware);

        await store.dispatch(BootstrapAction());
        await pumpEventQueue();
        await store.dispatch(SaveDayAction(entryForDay(0)));
        await pumpEventQueue();

        expect(store.state.streakState.count, 3);
        expect(store.state.streakState.bestEver, 3);
      });
    });

    group('when saving a day', () {
      test('adds the entry to the state', () async {
        final store = _dayStore(middleware);

        await store.dispatch(SaveDayAction(DayEntry(date: today, hasNewExperience: true)));

        expect(store.state.dayState.entryFor(today)?.hasNewExperience, isTrue);
      });

      test('persists the entry to the repository', () async {
        final store = _dayStore(middleware);

        await store.dispatch(SaveDayAction(DayEntry(date: today, meaningScore: MeaningScore.values.last)));
        await pumpEventQueue();

        expect(store.state.dayState.entries.length, 1);
        verify(() => repository.upsert(any())).called(1);
      });

      test('updates the streak count for consecutive days', () async {
        final preloaded = initialAppState().copyWith(
          dayState: initialAppState().dayState.copyWith(
            entries: {daysAgo(1): entryForDay(1)},
          ),
        );
        final store = _dayStore(middleware, initialState: preloaded);

        await store.dispatch(SaveDayAction(entryForDay(0)));
        await pumpEventQueue();

        expect(store.state.streakState.count, 2);
      });
    });
  });
}
