import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step19GridAlive extends OnboardingStep {
  const Step19GridAlive();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: SingleChildScrollView(
        child: OnboardingStaggeredColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Margins.spacingM,
          children: [
            Texts.xlBold(Strings.onboarding19Title),
            Texts.primaryMediumSoft(context, Strings.onboarding19Subtitle),
            const _YearGridIllustration(filledCount: 126),
            const SmallDivider(),
            Texts.primaryMediumSoft(context, Strings.onboarding19Footer),
          ],
        ),
      ),
    );
  }
}

class _YearGridIllustration extends StatefulWidget {
  const _YearGridIllustration({required this.filledCount});
  final int filledCount;

  @override
  State<_YearGridIllustration> createState() => _YearGridIllustrationState();
}

class _YearGridIllustrationState extends State<_YearGridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 15;
  static const _kTotalDays = 365;
  static const _kDotSpacing = 4.0;
  static const _kAnimationDurationMs = 5000;
  static const _kAnimationDuration = Duration(milliseconds: _kAnimationDurationMs);
  static const _kDelayBeforeAnimation = Duration(seconds: 1);

  late final AnimationController _controller;
  late final List<Color> _fillColors;
  late final int _highlightGridIndex;

  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    final rng = Random(42);
    _fillColors = List.generate(widget.filledCount, (_) => _randomIntensityColor(rng));
    _highlightGridIndex = widget.filledCount - 1;
    _controller = AnimationController(vsync: this, duration: _kAnimationDuration);
    _haptic = FlutterHaptic.instance;
    Future<void>.delayed(_kDelayBeforeAnimation, () {
      if (!mounted) return;
      _controller.forward();
      _haptic.vibrate(
        intensity: 0.3,
        duration: _kAnimationDurationMs,
      );
    });
  }

  static Color _randomIntensityColor(Random rng) {
    const options = <Color>[
      Color(0xFFF1F1F1),
      Color(0xFFA2A2A2),
      Color(0xFF717171),
      Color(0xFF404040),
      Color(0xFF0A0A0A),
    ];
    return options[rng.nextInt(options.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static double _computeHeight(double width) {
    final dotSize = (width - _kDotSpacing * (_kColumns - 1)) / _kColumns;
    final rows = (_kTotalDays / _kColumns).ceil();
    return rows * (dotSize + _kDotSpacing);
  }

  @override
  Widget build(BuildContext context) {
    final strokeColor = AppColors.strokeColor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Texts.primaryMediumCounter(
                context,
                Strings.yearLabel,
                (DateTime.now().year + 1).toString(),
              ),
              Texts.primaryMediumCounter(
                context,
                Strings.dayLabel,
                widget.filledCount.toString(),
              ),
              Texts.primaryMediumCounter(
                context,
                Strings.progressLabel,
                '${((widget.filledCount / _kTotalDays) * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: Margins.spacingS),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = _computeHeight(w);
              return SizedBox(
                width: w,
                height: h,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _YearLifeGridPainter(
                      columns: _kColumns,
                      totalDays: _kTotalDays,
                      filledCount: widget.filledCount,
                      highlightGridIndex: _highlightGridIndex,
                      dotSpacing: _kDotSpacing,
                      fillColors: _fillColors,
                      emptyStrokeColor: strokeColor,
                      highlightColor: AppColors.highlightColor,
                      revealProgress: _controller.value,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _YearLifeGridPainter extends CustomPainter {
  const _YearLifeGridPainter({
    required this.columns,
    required this.totalDays,
    required this.filledCount,
    required this.highlightGridIndex,
    required this.dotSpacing,
    required this.fillColors,
    required this.emptyStrokeColor,
    required this.highlightColor,
    required this.revealProgress,
  });

  static const _emptyStrokeWidth = 1.0;

  final int columns;
  final int totalDays;
  final int filledCount;
  final int highlightGridIndex;
  final double dotSpacing;
  final List<Color> fillColors;
  final Color emptyStrokeColor;
  final Color highlightColor;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - dotSpacing * (columns - 1)) / columns;
    final maxRadius = dotSize / 2;
    final emptyStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _emptyStrokeWidth
      ..color = emptyStrokeColor;

    final emptyStrokeRadius = maxRadius - _emptyStrokeWidth / 2;

    final continuousRevealed = revealProgress * filledCount;
    final animationComplete = revealProgress >= 1.0;

    for (var i = 0; i < totalDays; i++) {
      final col = i % columns;
      final row = i ~/ columns;
      final cx = col * (dotSize + dotSpacing) + maxRadius;
      final cy = row * (dotSize + dotSpacing) + maxRadius;
      final center = Offset(cx, cy);

      if (i >= filledCount) {
        canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
        continue;
      }

      final revealThreshold = i + 1;
      final fillColor = animationComplete && i == highlightGridIndex ? highlightColor : fillColors[i];

      if (continuousRevealed >= revealThreshold) {
        canvas.drawCircle(center, maxRadius, Paint()..color = fillColor);
      } else if (continuousRevealed > i) {
        final scale = continuousRevealed - i;
        final radius = maxRadius * scale.clamp(0.0, 1.0);
        if (radius > 0) {
          canvas.drawCircle(center, radius, Paint()..color = fillColor);
        }
      } else {
        canvas.drawCircle(center, emptyStrokeRadius, emptyStroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _YearLifeGridPainter old) =>
      old.revealProgress != revealProgress || old.emptyStrokeColor != emptyStrokeColor || old.fillColors != fillColors;
}
