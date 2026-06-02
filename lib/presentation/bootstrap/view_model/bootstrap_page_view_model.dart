import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

part 'bootstrap_page_view_model.freezed.dart';

enum BootstrapPageRedirect {
  splash,
  onboarding,
  home,
}

@freezed
abstract class BootstrapPageViewModel with _$BootstrapPageViewModel {
  const factory BootstrapPageViewModel({
    required BootstrapPageRedirect redirect,
  }) = _BootstrapPageViewModel;

  factory BootstrapPageViewModel.create(Store<AppState> store) {
    return BootstrapPageViewModel(
      redirect: _redirect(store),
    );
  }
}

BootstrapPageRedirect _redirect(Store<AppState> store) {
  final userState = store.state.userState;

  if (userState is UserStateSuccess) {
    final user = userState.user;
    if (user == null) {
      return BootstrapPageRedirect.onboarding;
    }

    return BootstrapPageRedirect.home;
  }

  return BootstrapPageRedirect.splash;
}
