import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_page_view_model.dart';

import '../../helpers/test_app_state.dart';
import '../../helpers/test_store_factory.dart';

void main() {
  group('WeeklySummaryPageViewModel', () {
    const intentBePresent = WeeklyIntent(id: 'intent-a', label: 'Be present');
    const intentExplore = WeeklyIntent(id: 'intent-b', label: 'Explore');
    const intentConnect = WeeklyIntent(id: 'intent-c', label: 'Connect');

    final dateOfBirth = DateTime(1990, 6, 15);
    final at = DateTime(2026, 6, 17);

    User makeUser() => User(
      id: '1',
      name: 'Adrien',
      dateOfBirth: dateOfBirth,
      gender: Gender.male,
      lifespan: 90,
      createdAt: DateTime(2024, 1, 1),
    );

    WeeklySummaryPageViewModel buildViewModel({
      required Map<DateTime, DayEntry> entries,
      List<String> selectedIntentIds = const ['intent-a', 'intent-b', 'intent-c'],
      UserState userState = const UserState.loading(),
      DateTime? referenceDate,
    }) {
      final store = TestStoreFactory().initializeReduxStore(
        initialAppState().copyWith(
          userState: userState,
          dayState: DayState(entries: entries),
          weeklyIntentState: WeeklyIntentState(
            availableIntents: const [intentBePresent, intentExplore, intentConnect],
            selectedIds: selectedIntentIds,
            currentWeekKey: '',
          ),
        ),
      );

      return WeeklySummaryPageViewModel.create(store, at: referenceDate ?? at);
    }

    test('exposes previous week date range and life week number', () {
      final vm = buildViewModel(
        entries: const {},
        userState: UserState.success(makeUser()),
      );

      expect(vm.weekDates, '8-14 June 2026');
      expect(
        vm.weekNumber,
        weeksSinceBirth(
          dateOfBirth: dateOfBirth,
          at: DateTime(2026, 6, 14),
          weekStartDay: DateTime.monday,
        ),
      );
    });

    test('aggregates averages, experiences, intentions, size levels and images from last week only', () {
      final vm = buildViewModel(
        userState: UserState.success(makeUser()),
        entries: {
          DateTime(2026, 6, 8): DayEntry(
            date: DateTime(2026, 6, 8),
            averageFeeling: AverageFeeling.good,
            meaningScore: MeaningScore.much,
            hasNewExperience: true,
            livingIntentionIds: const ['intent-a', 'intent-a', 'intent-b'],
            leaveATrace: const LeaveATrace(imagePaths: ['week/photo-1.png']),
            sizeLevel: 3,
          ),
          DateTime(2026, 6, 10): DayEntry(
            date: DateTime(2026, 6, 10),
            averageFeeling: AverageFeeling.okey,
            meaningScore: MeaningScore.some,
            hasNewExperience: false,
            livingIntentionIds: const ['intent-a'],
            leaveATrace: const LeaveATrace(imagePaths: ['week/photo-2.png']),
            sizeLevel: 2,
          ),
          DateTime(2026, 6, 17): DayEntry(
            date: DateTime(2026, 6, 17),
            averageFeeling: AverageFeeling.great,
            meaningScore: MeaningScore.deep,
            hasNewExperience: true,
            sizeLevel: 4,
          ),
        },
      );

      expect(vm.lastWeekAverageFeeling, AverageFeeling.good);
      expect(vm.lastWeekAverageFeelingScore, 3.5);
      expect(vm.lastWeekAverageMeaningScore, 3.5);
      expect(vm.lastWeekNewExperiencesCount, 1);
      expect(vm.lastWeekLivingIntentions, const [(3, 'Be present'), (1, 'Explore'), (0, 'Connect')]);
      expect(
        vm.lastWeekDaySizes,
        const [
          ('MO', 3),
          ('TU', null),
          ('WE', 2),
          ('TH', null),
          ('FR', null),
          ('SA', null),
          ('SU', null),
        ],
      );
      expect(vm.lastWeekImagePaths, ['week/photo-1.png', 'week/photo-2.png']);
    });

    test('returns neutral defaults when previous week has no entries', () {
      final vm = buildViewModel(
        entries: const {},
        userState: UserState.success(makeUser()),
      );

      expect(vm.lastWeekAverageFeeling, null);
      expect(vm.lastWeekAverageFeelingScore, 0);
      expect(vm.lastWeekAverageMeaningScore, 0);
      expect(vm.lastWeekNewExperiencesCount, 0);
      expect(vm.lastWeekLivingIntentions, const [(0, 'Be present'), (0, 'Explore'), (0, 'Connect')]);
      expect(
        vm.lastWeekDaySizes,
        const [
          ('MO', null),
          ('TU', null),
          ('WE', null),
          ('TH', null),
          ('FR', null),
          ('SA', null),
          ('SU', null),
        ],
      );
      expect(vm.lastWeekImagePaths, isEmpty);
    });

    test('returns zero week number when user is not loaded', () {
      final vm = buildViewModel(entries: const {});

      expect(vm.weekNumber, 0);
    });
  });
}
