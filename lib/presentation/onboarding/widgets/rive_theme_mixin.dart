import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:weeksalive/core/styles/app_colors.dart';

/// Provides automatic View Model theme binding for Rive animations.
///
/// Tracks [Brightness] changes via [didChangeDependencies] and pushes the
/// matching color to the `theme` property of the default View Model instance.
/// The [ViewModelInstance] is disposed automatically in [dispose].
///
/// Usage:
/// ```dart
/// class _MyState extends State<MyWidget> with RiveThemeMixin<MyWidget> {
///   @override
///   void dispose() {
///     myFileLoader.dispose();
///     super.dispose(); // calls mixin dispose → _vmi?.dispose()
///   }
/// }
/// ```
/// Then pass [onRiveLoaded] to `RiveWidgetBuilder.onLoaded`.
mixin RiveThemeMixin<T extends StatefulWidget> on State<T> {
  ViewModelInstance? _vmi;
  Brightness? _lastBrightness;

  /// Exposes the bound [ViewModelInstance] for subclasses that need to set
  /// additional VM properties (e.g. gender booleans).
  ViewModelInstance? get vmi => _vmi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_lastBrightness != brightness) {
      _lastBrightness = brightness;
      _applyTheme(brightness);
    }
  }

  @override
  void dispose() {
    _vmi?.dispose();
    super.dispose();
  }

  /// Pass this to `RiveWidgetBuilder.onLoaded`.
  void onRiveLoaded(RiveWidgetController controller) {
    _vmi = controller.dataBind(DataBind.auto());
    if (_lastBrightness != null) {
      _applyTheme(_lastBrightness!);
    }
  }

  void _applyTheme(Brightness brightness) {
    final vmi = _vmi;
    if (vmi == null) return;
    final color = AppColors.content(context);
    vmi.color('theme')?.value = color;
  }
}
