import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'home_page_view_model.freezed.dart';

@freezed
class HomePageViewModel with _$HomePageViewModel {
  const factory HomePageViewModel._({
    required String userName,
    required int streakCount,
    required LifeWeekGrid lifeWeekGrid,
  }) = _HomePageViewModel;

  factory HomePageViewModel.create(Store<AppState> store) {
    return HomePageViewModel._(
      userName: _userName(store),
      streakCount: store.state.streakState.count,
      lifeWeekGrid: _lifeWeekGrid(store),
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

LifeWeekGrid _lifeWeekGrid(Store<AppState> store) {
  final userState = store.state.userState;
  if (userState is UserStateSuccess) {
    final user = userState.user;
    if (user != null) {
      return LifeWeekGrid.fromProfile(
        dateOfBirth: user.dateOfBirth,
        projectedLifespanYears: user.lifespan,
        at: DateTime.now(),
      );
    }
  }
  return LifeWeekGrid.fromProfile(
    dateOfBirth: null,
    projectedLifespanYears: 85,
    at: DateTime.now(),
  );
}
