import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

const _kColumns = 52;
const _kTotalWeeks = 4681;
const _kLivedWeeks = 1560;
const _kDotSpacing = 2.4;
const _kAgeLegendWidth = 16.0;
const _kAgeMarkerWidth = 20.0;
const _kMarkerGap = 4.0;
const _kLegendIconSize = 16.0;
const _kLabelHeight = FontSizes.extraSmall;
const _kTopLegendHeight = 16.0;
const _kFirstAgeMarker = 10;
const _kAgeMarkerStep = 10;
const _kAnimationTick = Duration(milliseconds: 300);
const _kAnimatedRows = 30;

// Stagger delays for each content group.
const _kDelay1 = Duration(milliseconds: 300);
const _kDelay2 = Duration(milliseconds: 800);

class Step03LifeInWeeks extends OnboardingStep {
  const Step03LifeInWeeks();

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
                  _FadeSlideIn(
                    delay: _kDelay1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Texts.xlBold(Strings.onboarding03Title),
                        const SizedBox(height: Margins.spacingM),
                      ],
                    ),
                  ),
                  const _FadeSlideIn(
                    delay: _kDelay2,
                    child: _GridIllustration(),
                  ),
                  const SizedBox(height: Margins.spacingM),
                ],
              ),
            ),
          ),
        ),
      ],
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
    _timer = Timer.periodic(_kAnimationTick, (_) {
      setState(() {
        _extra = (_extra + 1) % (_kColumns * _kAnimatedRows + 1);
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
    final inactiveColor = AppColors.bgSoft(context);
    final accentColor = AppColors.accentOrange(context);
    final labelColor = AppColors.contentSoft(context);
    final legendColor = AppColors.content(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth - _kAgeLegendWidth - _kAgeMarkerWidth - _kMarkerGap;
        final dotSize = (gridWidth - _kDotSpacing * (_kColumns - 1)) / _kColumns;
        final gridHeight = _WeekGridPainter.computeHeight(
          availableWidth: gridWidth,
          totalWeeks: _kTotalWeeks,
          columns: _kColumns,
          dotSpacing: _kDotSpacing,
        );

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: _kAgeMarkerWidth + _kMarkerGap),
                  child: SizedBox(
                    width: gridWidth,
                    height: _kTopLegendHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: _AxisLegend(
                            label: Strings.onboarding03WeekOfTheYear,
                            trailingIcon: MingCuteIcons.mgc_arrow_right_line,
                            color: legendColor,
                          ),
                        ),
                        _GridLabel('$_kColumns', color: labelColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Margins.spacingS),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _kAgeMarkerWidth,
                      height: gridHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: _AxisLegend(
                                  label: Strings.profilePageAge,
                                  leadingIcon: MingCuteIcons.mgc_arrow_left_line,
                                  color: legendColor,
                                ),
                              ),
                            ),
                          ),
                          for (var age = _kFirstAgeMarker; age * _kColumns < _kTotalWeeks; age += _kAgeMarkerStep)
                            Positioned(
                              top: _rowCenterY(age, dotSize) - _kLabelHeight / 2,
                              left: 0,
                              right: 0,
                              child: _GridLabel(
                                '$age',
                                color: labelColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _kMarkerGap),
                    SizedBox(
                      width: gridWidth,
                      height: gridHeight,
                      child: CustomPaint(
                        painter: _WeekGridPainter(
                          columns: _kColumns,
                          totalWeeks: _kTotalWeeks,
                          livedWeeks: _kLivedWeeks + _extra,
                          dotSpacing: _kDotSpacing,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                          accentColor: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  double _rowCenterY(int age, double dotSize) => age * (dotSize + _kDotSpacing) + dotSize / 2;
}

class _GridLabel extends StatelessWidget {
  const _GridLabel(
    this.text, {
    required this.color,
    this.textAlign,
  });

  final String text;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyles.primaryXsBold.copyWith(color: color, height: 1),
    );
  }
}

class _AxisLegend extends StatelessWidget {
  const _AxisLegend({
    required this.label,
    required this.color,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final Color color;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final style = TextStyles.primarySmallMedium.copyWith(color: color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Margins.spacingXs,
      children: [
        if (leadingIcon != null) Icon(leadingIcon, size: _kLegendIconSize, color: color),
        Text(label, style: style),
        if (trailingIcon != null)
          SizedBox.square(
            dimension: style.fontSize,
            child: OverflowBox(
              alignment: Alignment.center,
              maxWidth: _kLegendIconSize,
              maxHeight: _kLegendIconSize,
              child: Icon(trailingIcon, size: _kLegendIconSize, color: color),
            ),
          ),
      ],
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
    required this.accentColor,
  });

  final int columns;
  final int totalWeeks;
  final int livedWeeks;
  final double dotSpacing;
  final Color activeColor;
  final Color inactiveColor;
  final Color accentColor;

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
    final accentPaint = Paint()..color = accentColor;

    for (var i = 0; i < totalWeeks; i++) {
      final col = i % columns;
      final row = i ~/ columns;
      final x = col * (dotSize + dotSpacing) + dotSize / 2;
      final y = row * (dotSize + dotSpacing) + dotSize / 2;
      final paint = i >= livedWeeks ? inactivePaint : (i == livedWeeks - 1 ? accentPaint : activePaint);
      canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_WeekGridPainter old) =>
      old.livedWeeks != livedWeeks ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.accentColor != accentColor;
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
