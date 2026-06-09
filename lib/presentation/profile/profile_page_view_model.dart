import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'profile_page_view_model.freezed.dart';

@freezed
abstract class ProfilePageViewModel with _$ProfilePageViewModel {
  const factory ProfilePageViewModel({
    required String userName,
    required DateTime dateOfBirth,
    required int lifespan,
    required int age,
    required int yearsAhead,
    required Gender gender,
    required bool notificationsEnabled,
    required int weekStartDay,
  }) = _ProfilePageViewModel;

  factory ProfilePageViewModel.create(Store<AppState> store, DateTime now) {
    final user = store.state.userState.userOrNull;
    final age = _userAge(user, now);
    final lifespan = user?.lifespan ?? 0;
    return ProfilePageViewModel(
      userName: user?.name ?? '',
      dateOfBirth: user?.dateOfBirth ?? now,
      lifespan: lifespan,
      age: _userAge(user, now),
      yearsAhead: lifespan - age,
      gender: user?.gender ?? Gender.other,
      notificationsEnabled: store.state.pushNotificationState.pushNotificationEnabled,
      weekStartDay: user?.weekStartDay ?? DateTime.monday,
    );
  }
}

int _userAge(User? user, DateTime now) {
  final dob = user?.dateOfBirth;
  if (dob == null) return 0;
  int age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age.clamp(0, 130);
}
