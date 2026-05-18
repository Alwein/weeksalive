import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

class Step19GridAlive extends OnboardingStep {
  const Step19GridAlive();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final bgColor = AppColors.bg(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.0, 0.88, 1.0],
              colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
            ).createShader(rect),
            blendMode: BlendMode.dstOut,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texts.xlBold(Strings.onboarding19Title),
                  const SizedBox(height: Margins.spacingM),
                  Texts.primaryMediumSoft(context, Strings.onboarding19Subtitle),
                  const SizedBox(height: Margins.spacingM),
                  _YearGridIllustration(filledCount: 126, isDarkMode: context.isDarkMode),
                  const SizedBox(height: Margins.spacingM),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SmallDivider(),
              const SizedBox(height: Margins.spacingBase),
              Texts.primaryMediumSoft(context, Strings.onboarding19Footer),
              const SizedBox(height: Margins.spacingBase),
            ],
          ),
        ),
      ],
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
  late final List<int> _fillSizes;
  late final int _highlightGridIndex;

  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    final rng = Random(42);
    _fillSizes = List.generate(widget.filledCount, (_) => _randomSizeLevel(rng));
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

  static int _randomSizeLevel(Random rng) {
    const weightedLevels = [0, 1, 2, 2, 3, 3, 4, 4, 4];
    return weightedLevels[rng.nextInt(weightedLevels.length)];
  }

  @override
  void dispose() {
    _haptic.cancel();
    _controller.dispose();
    super.dispose();
  }

  static double _computeHeight(double width) {
    return YearGridPainter.computeHeight(
      availableWidth: width,
      totalDays: _kTotalDays,
      columns: _kColumns,
      dotSpacing: _kDotSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strokeColor = AppColors.strokeColor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = _computeHeight(w);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Texts.primaryXsCounter(
                  context,
                  Strings.yearLabel,
                  (DateTime.now().year + 1).toString(),
                ),
                Texts.primaryXsCounter(
                  context,
                  Strings.dayLabel,
                  widget.filledCount.toString(),
                ),
                Texts.primaryXsCounter(
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
                  painter: YearGridPainter(
                    columns: _kColumns,
                    totalDays: _kTotalDays,
                    filledCount: widget.filledCount,
                    highlightGridIndex: _highlightGridIndex,
                    dotSpacing: _kDotSpacing,
                    fillSizes: _fillSizes,
                    fillColor: AppColors.content(context),
                    emptyStrokeColor: strokeColor,
                    highlightColor: AppColors.highlightColor,
                    revealProgress: _controller.value,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

extension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
