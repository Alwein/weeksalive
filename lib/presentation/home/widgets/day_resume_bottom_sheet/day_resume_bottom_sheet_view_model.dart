import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'day_resume_bottom_sheet_view_model.freezed.dart';

@freezed
abstract class DayResumeBottomSheetViewModel with _$DayResumeBottomSheetViewModel {
  const factory DayResumeBottomSheetViewModel.empty({
    required DateTime date,
  }) = DayResumeBottomSheetViewModelEmpty;

  const factory DayResumeBottomSheetViewModel.filled({
    required DayEntry entry,
    required int dayCount,
  }) = DayResumeBottomSheetViewModelFilled;

  factory DayResumeBottomSheetViewModel.create(Store<AppState> store, DateTime date) {
    final existingEntry = store.state.dayState.entryFor(date);
    if (existingEntry == null) {
      return DayResumeBottomSheetViewModel.empty(date: date);
    }

    final user = switch (store.state.userState) {
      UserStateSuccess(:final user) => user,
      _ => null,
    };

    return DayResumeBottomSheetViewModel.filled(
      entry: existingEntry,
      dayCount: user?.dayNumber(date) ?? 0,
    );
  }
}
