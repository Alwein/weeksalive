import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const _kColumns = 52;
const _kTotalWeeks = 3000;
const _kLivedWeeks = 1111;
const _kDotSpacing = 2.4;

// Stagger delays for each content group.
const _kDelay1 = Duration(milliseconds: 300);
const _kDelay2 = Duration(milliseconds: 800);
const _kDelay3 = Duration(milliseconds: 1200);

class Step03LifeInWeeks extends OnboardingStep {
  const Step03LifeInWeeks();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FadeSlideIn(
            delay: _kDelay1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Margins.spacingBase),
                Texts.xlBold(Strings.onboarding03Title),
                const SizedBox(height: Margins.spacingBase),
                Texts.primaryMediumSoft(context, Strings.onboarding03Subtitle),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
          const Expanded(
            child: _FadeSlideIn(
              delay: _kDelay2,
              child: _GridIllustration(),
            ),
          ),
          _FadeSlideIn(
            delay: _kDelay3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Margins.spacingM),
                const SmallDivider(),
                const SizedBox(height: Margins.spacingM),
                Texts.primaryMediumSoft(context, Strings.onboarding03Footer),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridIllustration extends StatefulWidget {
  const _GridIllustration();

  @override
  State<_GridIllustration> createState() => _GridIllustrationState();
}

class _GridIllustrationState extends State<_GridIllustration> {
  int _extra = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _extra = (_extra + 1) % (_kColumns + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
        stops: const [0.0, 0.0, 0.85, 1.0],
        colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
      ).createShader(rect),
      blendMode: BlendMode.dstOut,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final exactHeight = _WeekGridPainter.computeHeight(
            availableWidth: constraints.maxWidth,
            totalWeeks: _kTotalWeeks,
            columns: _kColumns,
            dotSpacing: _kDotSpacing,
          );
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              height: exactHeight,
              child: CustomPaint(
                painter: _WeekGridPainter(
                  columns: _kColumns,
                  totalWeeks: _kTotalWeeks,
                  livedWeeks: _kLivedWeeks + _extra,
                  dotSpacing: _kDotSpacing,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WeekGridPainter extends CustomPainter {
  const _WeekGridPainter({
    required this.columns,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.dotSpacing,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int columns;
  final int totalWeeks;
  final int livedWeeks;
  final double dotSpacing;
  final Color activeColor;
  final Color inactiveColor;

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
    final dotSize = (size.width - dotSpacing * (columns - 1)) / columns;

    final activePaint = Paint()..color = activeColor;
    final inactivePaint = Paint()..color = inactiveColor;

    for (var i = 0; i < totalWeeks; i++) {
      final col = i % columns;
      final row = i ~/ columns;
      final x = col * (dotSize + dotSpacing) + dotSize / 2;
      final y = row * (dotSize + dotSpacing) + dotSize / 2;
      canvas.drawCircle(Offset(x, y), dotSize / 2, i < livedWeeks ? activePaint : inactivePaint);
    }
  }

  @override
  bool shouldRepaint(_WeekGridPainter old) =>
      old.livedWeeks != livedWeeks || old.activeColor != activeColor || old.inactiveColor != inactiveColor;
}

class _FadeSlideIn extends StatefulWidget {
  const _FadeSlideIn({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AnimationDurations.long);
    _curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return widget.child;

    return FadeTransition(
      opacity: _curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(_curved),
        child: widget.child,
      ),
    );
  }
}
