import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step19GridAlive extends OnboardingStep {
  const Step19GridAlive();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texts.xlBold(Strings.onboarding19Title),
          const SizedBox(height: Margins.spacingM),
          Texts.primaryMediumSoft(context, Strings.onboarding19Subtitle),
          Expanded(
            child: _YearGridIllustration(filledCount: 126, isDarkMode: context.isDarkMode),
          ),
          const SmallDivider(),
          const SizedBox(height: Margins.spacingBase),
          Texts.primaryMediumSoft(context, Strings.onboarding19Footer),
          const SizedBox(height: Margins.spacingBase),
        ],
      ),
    );
  }
}

class _YearGridIllustration extends StatefulWidget {
  const _YearGridIllustration({required this.filledCount, required this.isDarkMode});
  final int filledCount;
  final bool isDarkMode;

  @override
  State<_YearGridIllustration> createState() => _YearGridIllustrationState();
}

class _YearGridIllustrationState extends State<_YearGridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 15;
  static const _kTotalDays = 365;
  static const _kDotSpacing = 4.0;
  static const _kAnimationDurationMs = 5000;
  static const _kAnimationDuration = Duration(milliseconds: _kAnimationDurationMs);
  static const _kDelayBeforeAnimation = Duration(milliseconds: 500);

  late final AnimationController _controller;
  late final List<Color> _fillColors;
  late final int _highlightGridIndex;

  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    final rng = Random(42);
    _fillColors = List.generate(widget.filledCount, (_) => _randomIntensityColor(rng, widget.isDarkMode));
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

  static Color _randomIntensityColor(Random rng, bool isDark) {
    const optionsLight = <Color>[
      Color(0xFFD4D4D4),
      Color(0xFFA2A2A2),
      Color(0xFF717171),
      Color(0xFF404040),
      Color(0xFF0A0A0A),
    ];
    const optionsDark = <Color>[
      Color(0xFF181818),
      Color(0xFF313131),
      Color(0xFF646464),
      Color(0xFFB7B7B7),
      Color(0xFFF1F1F1),
    ];
    const weightedIndices = [0, 1, 2, 3, 4, 4, 4, 4, 4, 4];
    final options = isDark ? optionsDark : optionsLight;
    return options[weightedIndices[rng.nextInt(weightedIndices.length)]];
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
    final bgColor = AppColors.bg(context);

    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.0, 0.90, 1.0],
        colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
      ).createShader(rect),
      blendMode: BlendMode.dstOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = _computeHeight(w);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Margins.spacingBase),
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
                  SizedBox(
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
                  ),
                ],
              ),
            );
          },
        ),
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

extension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
