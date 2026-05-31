import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step20WeeksThatStay extends OnboardingStep {
  const Step20WeeksThatStay();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Margins.spacingM,
              children: [
                const SizedBox(height: Margins.spacingBase),
                Texts.xlBold(Strings.onboarding15Title),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
                    child: _DotScaleIllustration(),
                  ),
                ),
                const SmallDivider(),
                Texts.primaryMediumSoft(context, Strings.onboarding15Footer),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotScaleIllustration extends StatefulWidget {
  @override
  State<_DotScaleIllustration> createState() => _DotScaleIllustrationState();
}

class _DotScaleIllustrationState extends State<_DotScaleIllustration> with SingleTickerProviderStateMixin {
  static const _dotSizes = [10.0, 20.0, 34.0, 50.0, 70.0];

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.content(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final t = _animation.value;
        const largestSize = 34.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Margins.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final targetSize in _dotSizes)
                  () {
                    final size = lerpDouble(largestSize, targetSize, t)!;
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }(),
              ],
            ),
            const SizedBox(height: Margins.spacingBase),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelsColumn(
                  lines: [
                    Strings.onboarding15LeftLabel1,
                    Strings.onboarding15LeftLabel2,
                    Strings.onboarding15LeftLabel3,
                  ],
                  color: AppColors.contentSoft(context),
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                _LabelsColumn(
                  lines: [
                    Strings.onboarding15RightLabel1,
                    Strings.onboarding15RightLabel2,
                    Strings.onboarding15RightLabel3,
                  ],
                  color: AppColors.content(context),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            const SizedBox(height: Margins.spacingM),
          ],
        );
      },
    );
  }
}

class _LabelsColumn extends StatelessWidget {
  const _LabelsColumn({
    required this.lines,
    required this.color,
    required this.textAlign,
  });

  final List<String> lines;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Text(
            line,
            style: TextStyles.primarySmallRegular.copyWith(color: color),
            textAlign: textAlign,
          ),
      ],
    );
  }
}
