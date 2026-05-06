import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/presentation/onboarding/widgets/rive_theme_mixin.dart';

/// A baby Rive animation suspended from an umbilical cord that reacts to the
/// device accelerometer with spring physics.
///
/// On devices without a sensor (simulators, desktop) the baby can be dragged
/// freely with a finger/mouse instead.
class UmbilicalPendulum extends StatefulWidget {
  const UmbilicalPendulum({
    super.key,
    required this.assetPath,
    this.babySize = 220.0,
    this.cordAnchorFraction = 0.00,
    this.maxSwing = 90.0,
    // ─────────────────────────────────────────────────────────────────────
    // TWEAK THESE to move the cord attachment point on the baby:
    //   • cordAttachX: 0.5 = horizontally centred on the baby (belly button)
    //                  < 0.5 = left, > 0.5 = right
    //   • cordAttachY: 0.5 = vertically centred
    //                  0.0 = top of the bounding box, 1.0 = bottom
    //                  ~0.35–0.45 typically lands around the navel area
    // ─────────────────────────────────────────────────────────────────────
    this.cordAttachX = 0.53,
    this.cordAttachY = 0.59,
  });

  final String assetPath;
  final double babySize;
  final double cordAnchorFraction;
  final double maxSwing;

  /// Horizontal attachment on the baby: 0.0 = left edge, 1.0 = right edge.
  final double cordAttachX;

  /// Vertical attachment on the baby: 0.0 = top edge, 1.0 = bottom edge.
  final double cordAttachY;

  @override
  State<UmbilicalPendulum> createState() => _UmbilicalPendulumState();
}

class _UmbilicalPendulumState extends State<UmbilicalPendulum>
    with SingleTickerProviderStateMixin, RiveThemeMixin<UmbilicalPendulum> {
  // ── Physics ──────────────────────────────────────────────────────────────
  static const _spring = SpringDescription(mass: 1.0, stiffness: 80.0, damping: 8.0);

  late SpringSimulation _springX;
  late SpringSimulation _springY;
  double _velX = 0;
  double _velY = 0;
  double _posX = 0;
  double _posY = 0;

  // Target driven by sensor or gesture
  double _targetX = 0;
  double _targetY = 0;

  // ── Ticker ────────────────────────────────────────────────────────────────
  late final Ticker _ticker;
  Duration? _lastTickTime;

  // ── Sensor ────────────────────────────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _sensorSub;
  bool _hasSensor = false;

  // ── Drag (fallback) ───────────────────────────────────────────────────────
  Offset? _dragStart;
  double _dragBaseX = 0;
  double _dragBaseY = 0;

  // ── Rive ──────────────────────────────────────────────────────────────────
  late final FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();

    _fileLoader = FileLoader.fromAsset(widget.assetPath, riveFactory: Factory.flutter);

    _resetSprings(0, 0);

    _ticker = createTicker(_onTick)..start();

    _sensorSub = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen(
      (event) {
        _hasSensor = true;
        final maxSwing = widget.maxSwing;
        _targetX = (-event.x / 9.8).clamp(-1.0, 1.0) * maxSwing;
        _targetY = (event.y / 9.8).clamp(-1.0, 1.0) * maxSwing * 0.6;
      },
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sensorSub?.cancel();
    _fileLoader.dispose();
    super.dispose();
  }

  // ── Spring helpers ────────────────────────────────────────────────────────

  void _resetSprings(double targetX, double targetY) {
    _springX = SpringSimulation(_spring, _posX, targetX, _velX);
    _springY = SpringSimulation(_spring, _posY, targetY, _velY);
  }

  void _onTick(Duration elapsed) {
    final last = _lastTickTime;
    _lastTickTime = elapsed;
    if (last == null) return;

    final dt = (elapsed - last).inMicroseconds / Duration.microsecondsPerSecond;
    if (dt <= 0) return;

    // Re-create springs each frame targeting the current sensor/drag target
    _resetSprings(_targetX, _targetY);

    final newX = _springX.x(dt);
    final newY = _springY.x(dt);
    _velX = _springX.dx(dt);
    _velY = _springY.dx(dt);

    if ((newX - _posX).abs() > 0.01 || (newY - _posY).abs() > 0.01) {
      setState(() {
        _posX = newX;
        _posY = newY;
      });
    }
  }

  // ── Gesture (drag fallback) ───────────────────────────────────────────────

  void _onDragStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _dragBaseX = _targetX;
    _dragBaseY = _targetY;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_dragStart == null || _hasSensor) return;
    final delta = details.localPosition - _dragStart!;
    final maxSwing = widget.maxSwing;
    _targetX = (_dragBaseX + delta.dx).clamp(-maxSwing, maxSwing);
    _targetY = (_dragBaseY + delta.dy).clamp(-maxSwing, maxSwing);
  }

  void _onDragEnd(DragEndDetails _) {
    if (_hasSensor) return;
    _targetX = 0;
    _targetY = 0;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cordColor = AppColors.content(context);

    return GestureDetector(
      onPanStart: _onDragStart,
      onPanUpdate: _onDragUpdate,
      onPanEnd: _onDragEnd,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final babySize = widget.babySize;

          // Anchor point: horizontally centred, near the top
          final anchorX = width / 2;
          final anchorY = height * widget.cordAnchorFraction;

          // Baby centre in the resting position is roughly mid-height
          final restCenterY = anchorY + babySize * 0.7;

          // Current baby centre with physics offset applied
          final babyCenterX = anchorX + _posX;
          final babyCenterY = restCenterY + _posY;

          // Top-left of the baby square
          final babyLeft = babyCenterX - babySize / 2;
          final babyTop = babyCenterY - babySize / 2;

          // Cord attaches at the configurable fraction of the baby bounding box
          final cordAttachX = babyLeft + babySize * widget.cordAttachX;
          final cordAttachY = babyTop + babySize * widget.cordAttachY;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Umbilical cord ─────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _UmbilicalCordPainter(
                    anchor: Offset(anchorX, anchorY),
                    attachment: Offset(cordAttachX, cordAttachY),
                    color: cordColor,
                  ),
                ),
              ),
              // ── Baby Rive widget ────────────────────────────────────────
              Positioned(
                left: babyLeft,
                top: babyTop,
                width: babySize,
                height: babySize,
                child: RiveWidgetBuilder(
                  fileLoader: _fileLoader,
                  onLoaded: (state) => onRiveLoaded(state.controller),
                  builder: (context, state) => switch (state) {
                    RiveLoading() => const SizedBox.expand(),
                    RiveFailed() => const SizedBox.shrink(),
                    RiveLoaded(:final controller) => RiveWidget(
                      controller: controller,
                      fit: Fit.contain,
                    ),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Umbilical Cord Painter ─────────────────────────────────────────────────

class _UmbilicalCordPainter extends CustomPainter {
  const _UmbilicalCordPainter({
    required this.anchor,
    required this.attachment,
    required this.color,
  });

  final Offset anchor;
  final Offset attachment;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dx = attachment.dx - anchor.dx;
    final dy = attachment.dy - anchor.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    final strokeWidth = (length / 80.0).clamp(3.0, 7.0);

    // Fade-in: transparent at the anchor (top), fully opaque after 25%
    // of the cord length going toward the attachment. TileMode.clamp keeps
    // the rest of the cord solid.
    final fadeEnd = Offset(
      anchor.dx + dx * 0.25,
      anchor.dy + dy * 0.25,
    );
    final shader = ui.Gradient.linear(
      anchor,
      fadeEnd,
      [color.withValues(alpha: 0), color],
      [0.0, 1.0],
      TileMode.clamp,
    );

    final paint = Paint()
      ..shader = shader
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = ui.PaintingStyle.stroke;

    final sag = length * 0.35;
    final cp1 = Offset(anchor.dx, anchor.dy + sag);
    final cp2 = Offset(attachment.dx, attachment.dy - sag * 0.2);

    final path = Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, attachment.dx, attachment.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_UmbilicalCordPainter old) =>
      old.anchor != anchor || old.attachment != attachment || old.color != color;
}
