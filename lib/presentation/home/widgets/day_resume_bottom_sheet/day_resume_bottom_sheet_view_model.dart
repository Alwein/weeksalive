import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/pro/free_plan.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/purchase/purchase_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'day_resume_bottom_sheet_view_model.freezed.dart';

@freezed
abstract class DayResumeBottomSheetViewModel with _$DayResumeBottomSheetViewModel {
  /// [canLog] is false for a missed day a free user cannot catch up on.
  const factory DayResumeBottomSheetViewModel.empty({
    required DateTime date,
    required bool canLog,
  }) = DayResumeBottomSheetViewModelEmpty;

  const factory DayResumeBottomSheetViewModel.filled({
    required DayEntry entry,
    required int dayCount,
  }) = DayResumeBottomSheetViewModelFilled;

  /// A recorded day outside the free history window.
  const factory DayResumeBottomSheetViewModel.locked({
    required DateTime date,
    required int sizeLevel,
    required int dayCount,
  }) = DayResumeBottomSheetViewModelLocked;

  factory DayResumeBottomSheetViewModel.create(Store<AppState> store, DateTime date, {DateTime? now}) {
    final at = now ?? DateTime.now();
    final isPro = store.state.purchaseState.isPro;
    final existingEntry = store.state.dayState.entryFor(date);
    if (existingEntry == null) {
      return DayResumeBottomSheetViewModel.empty(
        date: date,
        canLog: isPro || FreePlan.canOpenDayForm(date: date, hasEntry: false, now: at),
      );
    }

    final user = switch (store.state.userState) {
      UserStateSuccess(:final user) => user,
      _ => null,
    };
    final dayCount = user?.dayNumber(date) ?? 0;

    if (!isPro && !FreePlan.canReadDay(date, at)) {
      return DayResumeBottomSheetViewModel.locked(
        date: existingEntry.date,
        sizeLevel: existingEntry.sizeLevel,
        dayCount: dayCount,
      );
    }

    return DayResumeBottomSheetViewModel.filled(
      entry: existingEntry,
      dayCount: dayCount,
    );
  }
}
