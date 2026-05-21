import 'package:flutter/material.dart';

class AppBackgroundScaleController extends ChangeNotifier {
  AppBackgroundScaleController({double initialScale = 1.0}) : _scale = initialScale;

  double _scale;
  int _depth = 0;

  double get scale => _scale;

  void push({double scale = 0.97}) {
    _depth += 1;
    _scale = scale;
    notifyListeners();
  }

  void pop() {
    if (_depth <= 0) return;
    _depth -= 1;
    if (_depth == 0) {
      _scale = 1.0;
      notifyListeners();
    }
  }
}

class AppBackgroundScaleScope extends InheritedNotifier<AppBackgroundScaleController> {
  const AppBackgroundScaleScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppBackgroundScaleController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppBackgroundScaleScope>()?.notifier;
  }
}
