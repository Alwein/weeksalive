import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'home_page_view_model.freezed.dart';

@freezed
abstract class HomePageViewModel with _$HomePageViewModel {
  const factory HomePageViewModel({
    required String userName,
    required int streakCount,
    required LifeWeekGrid lifeWeekGrid,
    /// ISO weekday (1 = Monday … 7 = Sunday) at which the week starts.
    @Default(DateTime.monday) int weekStartDay,
    /// Set of dates (normalized to midnight) that have been recorded.
    @Default({}) Set<DateTime> recordedDays,
  }) = _HomePageViewModel;

  factory HomePageViewModel.create(Store<AppState> store) {
    return HomePageViewModel(
      userName: _userName(store),
      streakCount: store.state.streakState.count,
      lifeWeekGrid: _lifeWeekGrid(store),
      weekStartDay: _weekStartDay(store),
      recordedDays: store.state.dayState.entries.keys.toSet(),
    );
  }
}

String _userName(Store<AppState> store) {
  final userState = store.state.userState;
  if (userState is UserStateSuccess) {
    return userState.user?.name ?? '';
  }
  return '';
}

int _weekStartDay(Store<AppState> store) {
  final userState = store.state.userState;
  if (userState is UserStateSuccess) {
    return userState.user?.weekStartDay ?? DateTime.monday;
  }
  return DateTime.monday;
}

LifeWeekGrid _lifeWeekGrid(Store<AppState> store) {
  final userState = store.state.userState;
  if (userState is UserStateSuccess) {
    final user = userState.user;
    if (user != null) {
      return LifeWeekGrid.fromProfile(
        dateOfBirth: user.dateOfBirth,
        projectedLifespanYears: user.lifespan,
        at: DateTime.now(),
        weekStartDay: user.weekStartDay,
      );
    }
  }
  return LifeWeekGrid.fromProfile(
    dateOfBirth: null,
    projectedLifespanYears: 85,
    at: DateTime.now(),
  );
}
