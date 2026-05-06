import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class Step12VisitsVisualization extends OnboardingStep {
  const Step12VisitsVisualization();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final visits = controller.remainingVisits;
    final grid = controller.lifeWeekGrid;
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
                  Texts.xlBold(Strings.onboarding12Title(visits)),
                  const SizedBox(height: Margins.spacingM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
                    child: _GridIllustration(
                      totalWeeks: grid.totalWeeks,
                      livedWeeks: grid.livedWeeks,
                      remainingVisits: visits,
                    ),
                  ),
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
              Texts.primaryMediumSoft(
                context,
                Strings.onboarding12Subtitle,
              ),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridIllustration extends StatefulWidget {
  const _GridIllustration({required this.totalWeeks, required this.livedWeeks, required this.remainingVisits});
  final int totalWeeks;
  final int livedWeeks;
  final int remainingVisits;

  @override
  State<_GridIllustration> createState() => _GridIllustrationState();
}

class _GridIllustrationState extends State<_GridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;
  static const _kHighlightColor = AppColors.highlightColor;
  static const _kAnimationDurationMs = 5000;
  static const _kAnimationDuration = Duration(milliseconds: _kAnimationDurationMs);

  late final AnimationController _controller;
  late final List<int> _highlightedDots;
  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    _highlightedDots = _computeHighlightedDots();
    _controller = AnimationController(vsync: this, duration: _kAnimationDuration)..forward();
    _haptic = FlutterHaptic.instance;
    _haptic.playPattern(
      HapticPattern.custom(
        pattern: List.generate((_kAnimationDurationMs / 50).toInt(), (index) => 50),
        defaultIntensity: 0.3,
      ),
    );
  }

  List<int> _computeHighlightedDots() {
    final rng = Random(42);
    final firstRemainingRow = (widget.livedWeeks / _kColumns).ceil();
    final totalRows = (widget.totalWeeks / _kColumns).ceil();
    final dots = <int>[];

    for (var row = firstRemainingRow; row < totalRows; row++) {
      final rowStart = row * _kColumns;
      final rowEnd = (rowStart + _kColumns).clamp(0, widget.totalWeeks);
      final available = rowEnd - rowStart;
      if (available <= 0) continue;

      final positions = List<int>.generate(available, (i) => rowStart + i)..shuffle(rng);
      final picks = positions.take(2);
      for (final p in picks) {
        if (p >= widget.livedWeeks) dots.add(p);
      }
    }
    return dots;
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
    final inactiveColor = AppColors.bgSoft(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final exactHeight = WeekGridPainter.computeHeight(
          availableWidth: constraints.maxWidth,
          totalWeeks: widget.totalWeeks,
          columns: _kColumns,
          dotSpacing: _kDotSpacing,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Margins.spacingBase),
            Texts.primaryMediumCounter(
              context,
              Strings.visitsAheadLabel,
              widget.remainingVisits.toString(),
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
                    padding: const EdgeInsets.only(top: Margins.spacingS),
                    revealProgress: 1.0,
                    highlightedDots: _highlightedDots,
                    highlightColor: _kHighlightColor,
                    highlightRevealProgress: _controller.value,
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
