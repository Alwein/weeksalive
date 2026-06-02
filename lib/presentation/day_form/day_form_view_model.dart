import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'day_form_view_model.freezed.dart';

@freezed
abstract class DayFormViewModel with _$DayFormViewModel {
  const factory DayFormViewModel({
    required String dayCount,
    DayEntry? existingEntry,
  }) = _DayFormViewModel;

  factory DayFormViewModel.create(Store<AppState> store, DateTime date) {
    final user = switch (store.state.userState) {
      UserStateSuccess(:final user) => user,
      _ => null,
    };
    return DayFormViewModel(
      dayCount: _dayNumber(user, date).toString(),
      existingEntry: store.state.dayState.entryFor(date),
    );
  }
}

int _dayNumber(User? user, DateTime date) {
  final dateOfBirth = user?.dateOfBirth;
  if (dateOfBirth == null) return 1;
  final targetDay = DateTime(date.year, date.month, date.day);
  final birthDay = DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day);
  final diff = targetDay.difference(birthDay).inDays;
  return diff < 0 ? 1 : diff + 1;
}
