import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  final int currentIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps == 0 ? 0.0 : (currentIndex + 1) / totalSteps;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: AnimationDurations.base,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: AppColors.bgSoft(context),
          color: AppColors.content(context),
          borderRadius: BorderRadius.circular(Dimens.radiusS),
        );
      },
    );
  }
}
