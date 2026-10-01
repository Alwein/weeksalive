import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet_view_model.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';

void main() {
  final now = DateTime(2026, 9, 30, 15);
  DateTime daysAgo(int days) => DateTime(2026, 9, 30 - days);

  DayResumeBottomSheetViewModel create(DateTime date, {required bool isPro, List<DateTime> recorded = const []}) {
    final store = Store<AppState>(
      appReducer,
      initialState: AppState.initial().copyWith(
        purchaseState: PurchaseState.success(offering: null, isPro: isPro),
        dayState: DayState(
          entries: {for (final day in recorded) day: DayEntry(date: day, sizeLevel: 3)},
        ),
      ),
    );
    return DayResumeBottomSheetViewModel.create(store, date, now: now);
  }

  group('free user', () {
    test('reads a recorded day inside the history window', () {
      final vm = create(daysAgo(6), isPro: false, recorded: [daysAgo(6)]);

      expect(vm, isA<DayResumeBottomSheetViewModelFilled>());
    });

    test('sees a recorded day outside the history window as locked', () {
      final vm = create(daysAgo(7), isPro: false, recorded: [daysAgo(7)]);

      expect(vm, isA<DayResumeBottomSheetViewModelLocked>());
      expect((vm as DayResumeBottomSheetViewModelLocked).sizeLevel, 3);
    });

    test('can still log yesterday', () {
      final vm = create(daysAgo(1), isPro: false);

      expect((vm as DayResumeBottomSheetViewModelEmpty).canLog, isTrue);
    });

    test('cannot catch up on a missed day', () {
      final vm = create(daysAgo(3), isPro: false);

      expect((vm as DayResumeBottomSheetViewModelEmpty).canLog, isFalse);
    });
  });

  group('Pro user', () {
    test('reads any recorded day', () {
      final vm = create(daysAgo(40), isPro: true, recorded: [daysAgo(40)]);

      expect(vm, isA<DayResumeBottomSheetViewModelFilled>());
    });

    test('can catch up on a missed day', () {
      final vm = create(daysAgo(40), isPro: true);

      expect((vm as DayResumeBottomSheetViewModelEmpty).canLog, isTrue);
    });
  });
}
