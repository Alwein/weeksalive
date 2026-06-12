import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

/// Displays the full life-in-weeks grid (already revealed) and animates a list
/// of highlighted dots that light up one by one.
class HighlightedGridIllustration extends StatefulWidget {
  const HighlightedGridIllustration({
    super.key,
    required this.totalWeeks,
    required this.livedWeeks,
    required this.highlightedDots,
    this.caption,
    this.animationDurationMs = 3000,
    this.delayMs = 200,
    this.highlightColor,
  });

  final int totalWeeks;
  final int livedWeeks;
  final List<int> highlightedDots;
  final int animationDurationMs;
  final int delayMs;
  final Color? highlightColor;
  final Widget? caption;

  @override
  State<HighlightedGridIllustration> createState() => _HighlightedGridIllustrationState();
}

class _HighlightedGridIllustrationState extends State<HighlightedGridIllustration> with SingleTickerProviderStateMixin {
  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;

  late final AnimationController _controller;
  late final FlutterHaptic _haptic;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDurationMs),
    );
    _haptic = FlutterHaptic.instance;
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (!mounted) return;
      _controller.forward();
      _haptic.playPattern(
        HapticPattern.custom(
          pattern: List.generate((widget.animationDurationMs / 50).toInt(), (index) => 50),
          defaultIntensity: 0.3,
        ),
      );
    });
  }

  @override
  void dispose() {
    // _haptic.cancel();
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
            widget.caption ?? const SizedBox.shrink(),
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
                    highlightedDots: widget.highlightedDots,
                    highlightColor: widget.highlightColor ?? AppColors.accentOrange(context),
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
