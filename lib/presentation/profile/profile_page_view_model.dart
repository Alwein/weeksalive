import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/widgets/theme_picker.dart';

part 'profile_page_view_model.freezed.dart';

@freezed
abstract class ProfilePageViewModel with _$ProfilePageViewModel {
  const factory ProfilePageViewModel({
    required String userName,
    required String age,
    required String yearsAhead,
    required String dateOfBirth,
    required String lifespan,
    required String gender,
    required String notificationsEnabled,
    required String weekStartDay,
    required String weeklyIntents,
    required String theme,
    required String gridMotif,
    required String appIcon,
    required String wallpaperStatus,
  }) = _ProfilePageViewModel;

  factory ProfilePageViewModel.create(Store<AppState> store, DateTime now, {required String locale}) {
    final user = store.state.userState.userOrNull;
    final age = _userAge(user, now);
    final lifespan = user?.lifespan ?? 0;

    final weeklyState = store.state.weeklyIntentState;
    final selectedWeeklyIntents = weeklyState.availableIntents
        .where((i) => weeklyState.selectedIds.contains(i.id))
        .map((e) => e.localizedLabel)
        .join(', ');

    return ProfilePageViewModel(
      userName: user?.name ?? '',
      age: age.toString(),
      yearsAhead: (lifespan - age).toString(),
      dateOfBirth: DateFormat.yMMMd(locale).format(user?.dateOfBirth ?? now),
      lifespan: Strings.profilePageLifespanValue(lifespan),
      gender: (user?.gender ?? Gender.other).titleCase,
      notificationsEnabled: store.state.pushNotificationState.pushNotificationEnabled
          ? Strings.profilePageNotificationsEnabled
          : Strings.profilePageNotificationsDisabled,
      weekStartDay: Strings.weekdayFullNames[((user?.weekStartDay ?? DateTime.monday) - 1).clamp(0, 6)],
      weeklyIntents: selectedWeeklyIntents,
      theme: store.state.themeState.selectedTheme.label,
      gridMotif: store.state.gridMotifState.selectedMotif.label,
      appIcon: store.state.appIconState.selectedIcon.label,
      wallpaperStatus: store.state.wallpaperState.config.enabled
          ? Strings.profilePageWallpaperConfigured
          : Strings.profilePageWallpaperNotConfigured,
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
