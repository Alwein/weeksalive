import 'package:flutter/material.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';
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
const _kDotSpacing = 2.4;
const _kAgeMarkerWidth = 20.0;
const _kPhaseLegendWidth = 20.0;
const _kMarkerGap = 4.0;
const _kLegendIconSize = 16.0;
const _kLabelHeight = FontSizes.extraSmall;
const _kTopLegendHeight = 16.0;
const _kFirstAgeMarker = 10;
const _kAgeMarkerStep = 10;
const _kOrangeWeeksEnd = 338;
const _kMintWeeksEnd = 1222;
const _kPurpleWeeksEnd = 3328;
const _kRevealAnimationDurationMs = 3000;
const _kRevealAnimationDuration = Duration(milliseconds: _kRevealAnimationDurationMs);

// Stagger delays for each content group.
const _kDelay1 = Duration(milliseconds: 300);
const _kDelay2 = Duration(milliseconds: 800);

class Step03bLifeInWeeks extends OnboardingStep {
  const Step03bLifeInWeeks();

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
                        Texts.onboardingXlBold(Strings.onboarding03bTitle),
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

class _GridIllustrationState extends State<_GridIllustration> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  FlutterHaptic? _haptic;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kRevealAnimationDuration);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (disableAnimations) {
        _controller.value = 1.0;
        return;
      }

      _haptic = FlutterHaptic.instance;
      _haptic!.vibrate(
        intensity: 0.3,
        duration: _kRevealAnimationDurationMs,
      );
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _haptic?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final orangeColor = AppColors.accentOrange(context);
    final mintColor = AppColors.accentMint(context);
    final purpleColor = AppColors.accentPurple(context);
    final blueColor = AppColors.blueInfo(context);
    final labelColor = AppColors.contentSoft(context);
    final legendColor = AppColors.content(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth - _kAgeMarkerWidth - _kMarkerGap - _kPhaseLegendWidth - _kMarkerGap;
        final dotSize = (gridWidth - _kDotSpacing * (_kColumns - 1)) / _kColumns;
        final gridHeight = _WeekGridPainter.computeHeight(
          availableWidth: gridWidth,
          totalWeeks: _kTotalWeeks,
          columns: _kColumns,
          dotSpacing: _kDotSpacing,
        );
        final phases = [
          (start: 0, end: _kOrangeWeeksEnd, label: Strings.onboarding03bChildhood, color: orangeColor),
          (start: _kOrangeWeeksEnd, end: _kMintWeeksEnd, label: Strings.onboarding03bEducation, color: mintColor),
          (start: _kMintWeeksEnd, end: _kPurpleWeeksEnd, label: Strings.onboarding03bCareer, color: purpleColor),
          (start: _kPurpleWeeksEnd, end: _kTotalWeeks, label: Strings.onboarding03bRetirement, color: blueColor),
        ];

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final revealProgress = disableAnimations ? 1.0 : _controller.value;
            final revealedWeeks = revealProgress * _kTotalWeeks;
            final topLegendOpacity = (revealProgress * 20).clamp(0.0, 1.0);

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
                        child: Opacity(
                          opacity: topLegendOpacity,
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
                                child: Opacity(
                                  opacity: topLegendOpacity,
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
                              ),
                              for (var age = _kFirstAgeMarker; age * _kColumns < _kTotalWeeks; age += _kAgeMarkerStep)
                                Positioned(
                                  top: _rowCenterY(age, dotSize) - _kLabelHeight / 2,
                                  left: 0,
                                  right: 0,
                                  child: _RevealLabel(
                                    reveal: _markerReveal(revealedWeeks, age * _kColumns),
                                    child: _GridLabel(
                                      '$age',
                                      color: labelColor,
                                      textAlign: TextAlign.center,
                                    ),
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
                              dotSpacing: _kDotSpacing,
                              orangeColor: orangeColor,
                              mintColor: mintColor,
                              purpleColor: purpleColor,
                              blueColor: blueColor,
                              revealProgress: revealProgress,
                            ),
                          ),
                        ),
                        const SizedBox(width: _kMarkerGap),
                        SizedBox(
                          width: _kPhaseLegendWidth,
                          height: gridHeight,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              for (final phase in phases)
                                Positioned(
                                  top: _segmentTopY(phase.start, dotSize),
                                  height: _segmentHeight(phase.start, phase.end, dotSize),
                                  left: 0,
                                  right: 0,
                                  child: _RevealLabel(
                                    reveal: _phaseReveal(revealedWeeks, phase.start, phase.end),
                                    child: Center(
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: _GridLabel(phase.label, color: phase.color),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
      },
    );
  }
}

double _rowCenterY(int age, double dotSize) => age * (dotSize + _kDotSpacing) + dotSize / 2;

double _segmentTopY(int startWeek, double dotSize) => (startWeek / _kColumns) * (dotSize + _kDotSpacing);

double _segmentHeight(int startWeek, int endWeek, double dotSize) =>
    _segmentTopY(endWeek, dotSize) - _segmentTopY(startWeek, dotSize);

double _markerReveal(double revealedWeeks, int markerWeek) {
  if (revealedWeeks <= markerWeek) return 0;
  if (revealedWeeks >= markerWeek + 1) return 1;
  return revealedWeeks - markerWeek;
}

double _phaseReveal(double revealedWeeks, int start, int end) {
  if (revealedWeeks <= start) return 0;
  if (revealedWeeks >= end) return 1;
  return (revealedWeeks - start) / (end - start);
}

class _RevealLabel extends StatelessWidget {
  const _RevealLabel({required this.reveal, required this.child});

  final double reveal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (reveal <= 0) return const SizedBox.shrink();

    return Opacity(
      opacity: reveal,
      child: Transform.scale(
        scale: reveal,
        child: child,
      ),
    );
  }
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
      style: TextStyles.primarySmallBold.copyWith(color: color, height: 1),
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
    required this.dotSpacing,
    required this.orangeColor,
    required this.mintColor,
    required this.purpleColor,
    required this.blueColor,
    this.revealProgress = 1.0,
  });

  final int columns;
  final int totalWeeks;
  final double dotSpacing;
  final Color orangeColor;
  final Color mintColor;
  final Color purpleColor;
  final Color blueColor;
  final double revealProgress;

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

  Color _colorForWeek(int index) {
    if (index < _kOrangeWeeksEnd) return orangeColor;
    if (index < _kMintWeeksEnd) return mintColor;
    if (index < _kPurpleWeeksEnd) return purpleColor;
    return blueColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - dotSpacing * (columns - 1)) / columns;
    final revealed = revealProgress * totalWeeks;
    final fullyRevealedCount = revealed.floor();
    final currentDotScale = revealed - fullyRevealedCount;

    for (var i = 0; i < totalWeeks; i++) {
      if (i > fullyRevealedCount) break;

      final scale = i < fullyRevealedCount ? 1.0 : currentDotScale;
      if (scale <= 0) continue;

      final col = i % columns;
      final row = i ~/ columns;
      final x = col * (dotSize + dotSpacing) + dotSize / 2;
      final y = row * (dotSize + dotSpacing) + dotSize / 2;
      final paint = Paint()..color = _colorForWeek(i);
      canvas.drawCircle(Offset(x, y), dotSize / 2 * scale, paint);
    }
  }

  @override
  bool shouldRepaint(_WeekGridPainter old) =>
      old.revealProgress != revealProgress ||
      old.orangeColor != orangeColor ||
      old.mintColor != mintColor ||
      old.purpleColor != purpleColor ||
      old.blueColor != blueColor;
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
