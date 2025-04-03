import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fast_template/core/dependency_injection/locator.dart';
import 'package:flutter_fast_template/presentation/app/bloc/app_bloc.dart';
import 'package:flutter_fast_template/presentation/auth/bloc/auth_bloc.dart';

class AppBlocWrapper extends StatelessWidget {
  const AppBlocWrapper({super.key, required this.builder});
  final Widget Function(
    BuildContext context,
    AppState appState,
    AuthState authState,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: Locator.get<AppBloc>()..add(const AppEvent.initialize()),
        ),
        BlocProvider.value(
          value: Locator.get<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) => BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return builder(
              context,
              appState,
              authState,
            );
          },
        ),
      ),
    );
  }
}
