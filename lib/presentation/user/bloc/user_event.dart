part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.initialize({required String userId}) = _Initialize;
  const factory UserEvent.userChanged(User? user) = _UserChanged;
}
