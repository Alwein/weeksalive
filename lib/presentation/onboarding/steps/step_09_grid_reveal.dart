import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class Step09GridReveal extends OnboardingStep {
  const Step09GridReveal();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final name = controller.name ?? 'You';
    final grid = controller.lifeWeekGrid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texts.xlBold(Strings.onboarding09Title(name)),
          Expanded(
            child: Center(
              child: _GridIllustration(
                totalWeeks: grid.totalWeeks,
                livedWeeks: grid.livedWeeks,
                progressFraction: grid.progressFraction,
              ),
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
        ],
      ),
    );
  }
}

class _GridIllustration extends StatefulWidget {
  const _GridIllustration({
    required this.totalWeeks,
    required this.livedWeeks,
    required this.progressFraction,
  });
  final int totalWeeks;
  final int livedWeeks;
  final double progressFraction;

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

  static const _kGridPadding = EdgeInsets.only(
    left: Margins.spacingL,
    right: Margins.spacingL,
    top: Margins.spacingS,
  );

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.content(context);
    final inactiveColor = AppColors.bgSoft(context);
    final bgColor = AppColors.bg(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final exactHeight = WeekGridPainter.computeHeight(
          availableWidth: constraints.maxWidth,
          totalWeeks: widget.totalWeeks,
          columns: _kColumns,
          dotSpacing: _kDotSpacing,
          padding: _kGridPadding,
        );
        final needsScroll = exactHeight > constraints.maxHeight;

        final scrollContent = SingleChildScrollView(
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
                      '${(widget.progressFraction * 100).toStringAsFixed(2)}%',
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
                      padding: _kGridPadding,
                      revealProgress: _controller.value,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        if (!needsScroll) return scrollContent;

        return ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.0, 0.90, 1.0],
            colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
          ).createShader(rect),
          blendMode: BlendMode.dstOut,
          child: scrollContent,
        );
      },
    );
  }
}
