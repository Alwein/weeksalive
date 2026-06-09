import 'package:weeksalive/domain/user/user.dart';

class SetUserAction {
  final User user;
  const SetUserAction(this.user);
}

class ClearUserAction {
  const ClearUserAction();
}

class UserLoadedAction {
  final User? user;
  const UserLoadedAction(this.user);
}

class UpdateUserAction {
  final String name;
  final DateTime dateOfBirth;
  final Gender gender;
  final int lifespan;
  final int weekStartDay;

  const UpdateUserAction({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.lifespan,
    required this.weekStartDay,
  });
}
