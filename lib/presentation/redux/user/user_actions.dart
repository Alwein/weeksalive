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
