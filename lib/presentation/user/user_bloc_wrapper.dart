import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fast_template/presentation/user/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';

class UserBlocWrapper extends StatelessWidget {
  const UserBlocWrapper({super.key, required this.child, required this.userId});
  final Widget child;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I.get<UserBloc>()..add(UserEvent.initialize(userId: userId)),
      child: child,
    );
  }
}
