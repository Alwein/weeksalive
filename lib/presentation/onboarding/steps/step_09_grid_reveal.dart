import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step09GridReveal extends OnboardingStep {
  const Step09GridReveal();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final name = controller.name ?? 'You';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texts.xlBold(Strings.onboarding09Title(name)),
          Expanded(
            child: _GridIllustration(
              totalWeeks: controller.lifespan * 52,
              livedWeeks: controller.currentAge + controller.currentAgeInWeeks,
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
        ],
      ),
    );
  }
}

class _GridIllustration extends StatefulWidget {
  const _GridIllustration({required this.totalWeeks, required this.livedWeeks});
  final int totalWeeks;
  final int livedWeeks;

  @override
  State<_GridIllustration> createState() => _GridIllustrationState();
}

class _GridIllustrationState extends State<_GridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;
  static const _animationDurationMs = 3000;
  static const _kAnimationDuration = Duration(milliseconds: _animationDurationMs);

  late final AnimationController _controller;
  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kAnimationDuration)..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _haptic = FlutterHaptic.instance;
      _haptic.vibrate(
        intensity: 0.3,
        duration: _animationDurationMs,
      );
    });
  }

  @override
  void dispose() {
    _haptic.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.content(context);
    final inactiveColor = AppColors.strokeColor(context);
    final bgColor = AppColors.bg(context);

    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.0, 0.90, 1.0],
        colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
      ).createShader(rect),
      blendMode: BlendMode.dstOut,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final exactHeight = WeekGridPainter.computeHeight(
            availableWidth: constraints.maxWidth,
            totalWeeks: widget.totalWeeks,
            columns: _kColumns,
            dotSpacing: _kDotSpacing,
          );
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: Margins.spacingBase),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                  child: Row(
                    spacing: Margins.spacingBase,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Texts.primaryMediumCounter(
                        context,
                        Strings.progressLabel,
                        '${(widget.livedWeeks / widget.totalWeeks * 100).toStringAsFixed(2)}%',
                      ),
                      Texts.primaryMediumCounter(
                        context,
                        Strings.weekLabel,
                        widget.livedWeeks.toString(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: exactHeight,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: WeekGridPainter(
                        columns: _kColumns,
                        totalWeeks: widget.totalWeeks,
                        livedWeeks: widget.livedWeeks,
                        dotSpacing: _kDotSpacing,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        padding: const EdgeInsets.only(
                          left: Margins.spacingL,
                          right: Margins.spacingL,
                          top: Margins.spacingS,
                        ),
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
    );
  }
}

class WeekGridPainter extends CustomPainter {
  const WeekGridPainter({
    required this.columns,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.dotSpacing,
    required this.activeColor,
    required this.inactiveColor,
    required this.padding,
    this.revealProgress = 1.0,
    this.highlightedDots = const [],
    this.highlightColor,
    this.highlightRevealProgress = 1.0,
  });

  final int columns;
  final int totalWeeks;
  final int livedWeeks;
  final double dotSpacing;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final double revealProgress;

  /// Indices (within the full grid) of dots to highlight.
  final List<int> highlightedDots;

  /// Color used for highlighted dots.
  final Color? highlightColor;

  /// Progress from 0.0 to 1.0 controlling how many highlighted dots are visible.
  /// At 0.0 none are shown; at 1.0 all are shown, appearing one by one.
  final double highlightRevealProgress;

  static double computeHeight({
    required double availableWidth,
    required int totalWeeks,
    required int columns,
    required double dotSpacing,
  }) {
    final dotSize = (availableWidth - dotSpacing * (columns - 1)) / columns;
    final rows = (totalWeeks / columns).ceil();
    return rows * (dotSize + dotSpacing);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - padding.left - padding.right - dotSpacing * (columns - 1)) / columns;
    final maxRadius = dotSize / 2;

    // revealProgress goes from 0 to 1 over totalWeeks dots.
    // revealed is the continuous count of dots that should be visible.
    final revealed = revealProgress * totalWeeks;
    final fullyRevealedCount = revealed.floor();
    // fractional part drives the scale of the currently-appearing dot
    final currentDotScale = revealed - fullyRevealedCount;

    final activePaint = Paint()..color = activeColor;
    final inactivePaint = Paint()..color = inactiveColor;

    for (var i = 0; i < totalWeeks; i++) {
      if (i > fullyRevealedCount) break;

      final col = i % columns;
      final row = i ~/ columns;
      final x = padding.left + col * (dotSize + dotSpacing) + maxRadius;
      final y = padding.top + row * (dotSize + dotSpacing) + maxRadius;
      final paint = i < livedWeeks ? activePaint : inactivePaint;

      if (i < fullyRevealedCount) {
        canvas.drawCircle(Offset(x, y), maxRadius, paint);
      } else {
        // This is the dot currently appearing — scale its radius from 0 to full
        final radius = maxRadius * currentDotScale;
        if (radius > 0) canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    // Draw highlighted dots on top, appearing one by one.
    if (highlightedDots.isNotEmpty && highlightColor != null) {
      final totalHighlighted = highlightedDots.length;
      final continuousVisible = highlightRevealProgress * totalHighlighted;
      final fullyVisible = continuousVisible.floor();
      final partialScale = continuousVisible - fullyVisible;

      for (var hi = 0; hi < totalHighlighted; hi++) {
        if (hi >= fullyVisible + 1) break;
        final dotIndex = highlightedDots[hi];
        if (dotIndex >= totalWeeks) continue;

        // Skip dots that haven't been revealed by revealProgress yet.
        if (dotIndex >= fullyRevealedCount) continue;

        final col = dotIndex % columns;
        final row = dotIndex ~/ columns;
        final x = padding.left + col * (dotSize + dotSpacing) + maxRadius;
        final y = padding.top + row * (dotSize + dotSpacing) + maxRadius;

        final double radius;
        if (hi < fullyVisible) {
          radius = maxRadius;
        } else {
          radius = maxRadius * partialScale;
        }

        if (radius > 0) {
          canvas.drawCircle(
            Offset(x, y),
            radius,
            Paint()..color = highlightColor!,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(WeekGridPainter old) =>
      old.revealProgress != revealProgress ||
      old.highlightRevealProgress != highlightRevealProgress ||
      old.livedWeeks != livedWeeks ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.highlightColor != highlightColor ||
      old.highlightedDots != highlightedDots;
}
