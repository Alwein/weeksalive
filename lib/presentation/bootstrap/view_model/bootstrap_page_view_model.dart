import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

part 'bootstrap_page_view_model.freezed.dart';

@freezed
class BootstrapPageViewModel with _$BootstrapPageViewModel {
  const factory BootstrapPageViewModel._({
    required bool showOnboarding,
  }) = _BootstrapPageViewModel;

  factory BootstrapPageViewModel.create(Store<AppState> store) {
    return BootstrapPageViewModel._(
      showOnboarding: store.state.userState.map(
        loading: (_) => false,
        success: (_) => false,
        error: (_) => true,
      ),
    );
  }
}
