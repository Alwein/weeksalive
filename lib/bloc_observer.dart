// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:flutter_fast_template/core/utils/logger.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver();

  final List<dynamic> _events = [];

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _recordEvent(event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.e("🔴 $error");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log.i("$change".replaceAll("currentState", "\n🟠 currentState").replaceAll("nextState", "\n🟢 nextState"));
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  void _recordEvent(Object? event) {
    if (_events.length > 100) {
      _events.removeAt(0);
    }
    _events.add(event);
  }
}
