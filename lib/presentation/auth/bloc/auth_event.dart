part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
  const factory AuthEvent.userChanged({required User? user}) = UserChanged;
}
