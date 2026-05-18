import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step13WeeksDisappear extends OnboardingStep {
  const Step13WeeksDisappear();

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
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: Margins.spacingS),
                      Texts.xlBold(Strings.onboarding13Title),
                      const SizedBox(height: Margins.spacingBase),
                      Texts.primaryMediumSoft(context, Strings.onboarding13Subtitle),
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryXsCounter(context, Strings.lastYearWeeksLabel, '52 ${Strings.weeksLabel}'),
                      const SizedBox(height: Margins.spacingBase),
                      _YearWeeksIllustration(),
                      const SizedBox(height: Margins.spacingBase),
                      _Caption(),
                      const SizedBox(height: Margins.spacingM),
                    ],
                  ),
                ),
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
              const SizedBox(height: Margins.spacingM),
              Texts.primaryMediumBold(Strings.onboarding13Footer),
              const SizedBox(height: Margins.spacingS),
              Texts.primaryMediumSoft(context, Strings.onboarding13Footer2),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        ),
      ],
    );
  }
}

class _YearWeeksIllustration extends StatefulWidget {
  @override
  State<_YearWeeksIllustration> createState() => _YearWeeksIllustrationState();
}

class _YearWeeksIllustrationState extends State<_YearWeeksIllustration> with TickerProviderStateMixin {
  static const _kTotal = 52;
  static const _kKept = 8;
  static const _kFadeDuration = Duration(seconds: 2);
  static const _kTotalDuration = Duration(seconds: 8);

  late final List<AnimationController> _controllers;

  /// Indices that will fade out (44 out of 52), in fade-out order.
  late final List<int> _fadingIndices;

  @override
  void initState() {
    super.initState();

    final rng = Random(7);
    final allIndices = List<int>.generate(_kTotal, (i) => i)..shuffle(rng);
    _fadingIndices = allIndices.sublist(0, _kTotal - _kKept);

    // Spread start times evenly across the total duration minus the fade duration.
    final spreadMs = _kTotalDuration.inMilliseconds - _kFadeDuration.inMilliseconds;
    final count = _fadingIndices.length;

    _controllers = List.generate(count, (i) {
      final delayMs = count > 1 ? (spreadMs * i / (count - 1)).round() : 0;
      final ctrl = AnimationController(vsync: this, duration: _kFadeDuration);
      Future.delayed(Duration(milliseconds: delayMs), () {
        if (mounted) ctrl.forward();
      });
      return ctrl;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.content(context);
    final softColor = AppColors.bgSoft(context);

    // Map each grid index to its fade controller (if it fades), or null.
    final controllerByIndex = <int, AnimationController>{};
    for (var i = 0; i < _fadingIndices.length; i++) {
      controllerByIndex[_fadingIndices[i]] = _controllers[i];
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 13,
        childAspectRatio: 1.0,
        mainAxisSpacing: Margins.spacingXs,
        crossAxisSpacing: Margins.spacingXs,
      ),
      itemCount: _kTotal,
      itemBuilder: (context, index) {
        final ctrl = controllerByIndex[index];
        if (ctrl == null) {
          return Container(
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(360),
            ),
          );
        }
        return AnimatedBuilder(
          animation: ctrl,
          builder: (context, _) {
            final color = Color.lerp(activeColor, softColor, ctrl.value)!;
            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(360),
              ),
            );
          },
        );
      },
    );
  }
}

class _Caption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _circle(AppColors.content(context)),
              const SizedBox(width: Margins.spacingS),
              Flexible(child: Texts.primaryXsMediumSoft(context, Strings.onboarding13Caption1)),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _circle(AppColors.bgSoft(context)),
              const SizedBox(width: Margins.spacingS),
              Flexible(child: Texts.primaryXsMediumSoft(context, Strings.onboarding13Caption2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circle(Color color) => Circle(
    size: 16,
    color: color,
  );
}
