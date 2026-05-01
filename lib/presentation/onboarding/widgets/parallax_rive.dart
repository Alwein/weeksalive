import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';

class ParallaxRive extends StatefulWidget {
  final String assetPath;
  final Fit fit;

  /// Maximum pixel offset applied on each axis.
  final double maxOffset;

  /// Smoothing factor: how fast the offset interpolates toward the target (0–1).
  final double smoothing;

  const ParallaxRive({
    super.key,
    required this.assetPath,
    this.fit = Fit.contain,
    this.maxOffset = 50.0,
    this.smoothing = 0.08,
  });

  @override
  State<ParallaxRive> createState() => _ParallaxRiveState();
}

class _ParallaxRiveState extends State<ParallaxRive>
    with SingleTickerProviderStateMixin, RiveThemeMixin<ParallaxRive> {
  late final Ticker _ticker;
  StreamSubscription<AccelerometerEvent>? _subscription;
  late final FileLoader _fileLoader;

  Offset _target = Offset.zero;
  Offset _current = Offset.zero;

  @override
  void initState() {
    super.initState();

    _fileLoader = FileLoader.fromAsset(widget.assetPath, riveFactory: Factory.flutter);

    _ticker = createTicker(_onTick)..start();

    _subscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometer);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _subscription?.cancel();
    _fileLoader.dispose();
    super.dispose(); // calls RiveThemeMixin.dispose → _vmi?.dispose()
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final dx = (-event.x / 9.8).clamp(-1.0, 1.0) * widget.maxOffset;
    final dy = (event.y / 9.8).clamp(-1.0, 1.0) * widget.maxOffset;
    _target = Offset(dx, dy);
  }

  void _onTick(Duration _) {
    final next = Offset.lerp(_current, _target, widget.smoothing)!;
    if ((next - _current).distanceSquared > 0.001) {
      setState(() => _current = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: _current,
        child: RiveWidgetBuilder(
          fileLoader: _fileLoader,
          onLoaded: (state) => onRiveLoaded(state.controller),
          builder: (context, state) => switch (state) {
            RiveLoading() => const SizedBox.expand(),
            RiveFailed() => const SizedBox.shrink(),
            RiveLoaded(:final controller) => RiveWidget(
              controller: controller,
              fit: widget.fit,
            ),
          },
        ),
      ),
    );
  }
}
