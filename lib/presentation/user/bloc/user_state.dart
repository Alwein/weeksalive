part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(UserStatus.initial()) UserStatus status,
  }) = _UserState;
}

@freezed
class UserStatus with _$UserStatus {
  const factory UserStatus.initial() = _Initial;
  const factory UserStatus.loading() = _Loading;
  const factory UserStatus.success(User user) = _Success;
  const factory UserStatus.error() = _Error;
}

extension UserStateExt on UserState {
  String? get userIdOrNull => status.maybeWhen(
        success: (user) => user.id,
        orElse: () => null,
      );

  bool get isUserPremium => status.maybeWhen(
        success: (user) => user.premiumPlan != null,
        orElse: () => false,
      );

  bool get isNotUserPremium => !isUserPremium;

  User? get userOrNull => status.maybeWhen(
        success: (user) => user,
        orElse: () => null,
      );
}
