import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/year_grid_painter.dart';

class YearGridIllustration extends StatefulWidget {
  const YearGridIllustration({
    super.key,
    required this.filledCount,
    required this.wheightDistribution,
    this.header,
    this.animationDurationMs = 5000,
  });
  final int filledCount;
  final List<int> wheightDistribution;
  final Widget? header;
  final int animationDurationMs;

  @override
  State<YearGridIllustration> createState() => _YearGridIllustrationState();
}

class _YearGridIllustrationState extends State<YearGridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 15;
  static const _kTotalDays = 365;
  static const _kDotSpacing = 4.0;
  late final Duration _kAnimationDuration;
  static const _kDelayBeforeAnimation = Duration(milliseconds: 500);

  late final AnimationController _controller;
  late final List<int> _fillSizes;
  late final int _highlightGridIndex;

  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    _kAnimationDuration = Duration(milliseconds: widget.animationDurationMs);
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
        duration: widget.animationDurationMs,
      );
    });
  }

  int _randomSizeLevel(Random rng) {
    final weightedLevels = widget.wheightDistribution;
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
            widget.header ??
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
