import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_middleware.dart';
import 'package:weeksalive/presentation/redux/streak/streak_middleware.dart';

import '../../../helpers/test_app_state.dart';
import '../../../mocks.dart';

/// Isolated store wired with only the day + streak middlewares to avoid async
/// dispatch interference from the other middlewares during bootstrap.
Store<AppState> _dayStore(
  DayMiddleware dayMiddleware,
  StreakMiddleware streakMiddleware, {
  AppState? initialState,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState ?? initialAppState(),
    middleware: [dayMiddleware.call, streakMiddleware.call],
  );
}

void main() {
  group('day state', () {
    late MockDayRepository repository;
    late MockStreakRepository streakRepository;
    late DayMiddleware middleware;
    late StreakMiddleware streakMiddleware;

    final today = DateTime.now();
    DateTime daysAgo(int n) => DateTime(today.year, today.month, today.day).subtract(Duration(days: n));

    setUp(() {
      repository = MockDayRepository();
      streakRepository = MockStreakRepository();
      middleware = DayMiddleware(dayRepository: repository);
      streakMiddleware = StreakMiddleware(streakRepository: streakRepository);
    });

    group('when bootstrapping the app', () {
      test('loads stored days into the state', () async {
        final entries = [
          DayEntry(date: daysAgo(0), hasNewExperience: true),
          DayEntry(date: daysAgo(1), hasNewExperience: true),
        ];
        when(() => repository.getAll()).thenAnswer((_) => Future.sync(() => entries));
        final store = _dayStore(middleware, streakMiddleware);

        await store.dispatch(BootstrapAction());
        await pumpEventQueue();

        expect(store.state.dayState.entries.length, 2);
      });

      test('recomputes the streak when a day is later saved', () async {
        final entries = [
          DayEntry(date: daysAgo(1)),
          DayEntry(date: daysAgo(2)),
        ];
        when(() => repository.getAll()).thenAnswer((_) => Future.sync(() => entries));
        final store = _dayStore(middleware, streakMiddleware);

        await store.dispatch(BootstrapAction());
        await pumpEventQueue();
        await store.dispatch(SaveDayAction(DayEntry(date: daysAgo(0))));
        await pumpEventQueue();

        expect(store.state.streakState.count, 3);
      });
    });

    group('when saving a day', () {
      test('adds the entry to the state', () async {
        final store = _dayStore(middleware, streakMiddleware);

        await store.dispatch(SaveDayAction(DayEntry(date: today, hasNewExperience: true)));

        expect(store.state.dayState.entryFor(today)?.hasNewExperience, isTrue);
      });

      test('persists the entry to the repository', () async {
        final store = _dayStore(middleware, streakMiddleware);

        await store.dispatch(SaveDayAction(DayEntry(date: today, meaningScore: MeaningScore.values.last)));
        await pumpEventQueue();

        expect(store.state.dayState.entries.length, 1);
        verify(() => repository.upsert(any())).called(1);
      });

      test('updates the streak count for consecutive days', () async {
        final preloaded = initialAppState().copyWith(
          dayState: initialAppState().dayState.copyWith(
            entries: {daysAgo(1): DayEntry(date: daysAgo(1))},
          ),
        );
        final store = _dayStore(middleware, streakMiddleware, initialState: preloaded);

        await store.dispatch(SaveDayAction(DayEntry(date: today)));
        await pumpEventQueue();

        expect(store.state.streakState.count, 2);
      });
    });
  });
}
