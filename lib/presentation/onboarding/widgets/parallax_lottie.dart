import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ParallaxLottie extends StatefulWidget {
  final String assetPath;
  final ColorFilter? colorFilter;

  /// Maximum pixel offset applied on each axis.
  final double maxOffset;

  /// Smoothing factor: how fast the offset interpolates toward the target (0–1).
  final double smoothing;

  const ParallaxLottie({
    super.key,
    required this.assetPath,
    this.colorFilter,
    this.maxOffset = 50.0,
    this.smoothing = 0.08,
  });

  @override
  State<ParallaxLottie> createState() => _ParallaxLottieState();
}

class _ParallaxLottieState extends State<ParallaxLottie> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  StreamSubscription<AccelerometerEvent>? _subscription;

  Offset _target = Offset.zero;
  Offset _current = Offset.zero;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();

    _subscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometer);
  }

  void _onAccelerometer(AccelerometerEvent event) {
    // event.x: tilt left/right, event.y: tilt forward/back
    // Clamp to [-1, 1] then scale to maxOffset.
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
  void dispose() {
    _ticker.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget lottie = Lottie.asset(
      widget.assetPath,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
    );

    if (widget.colorFilter != null) {
      lottie = ColorFiltered(colorFilter: widget.colorFilter!, child: lottie);
    }

    return ClipRect(
      child: Transform.translate(
        offset: _current,
        child: lottie,
      ),
    );
  }
}
