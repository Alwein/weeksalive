import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/domain/user/user.dart';

part 'user_state.freezed.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.loading() = UserStateLoading;
  const factory UserState.success(User? user) = UserStateSuccess;
  const factory UserState.error(String message) = UserStateError;
}
