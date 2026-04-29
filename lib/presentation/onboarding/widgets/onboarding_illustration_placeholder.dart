import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';

/// Temporary placeholder shown during early onboarding iterations.
///
/// Displays the name of the illustration so the product team knows which
/// asset is expected there. To be replaced by the real illustration widget.
class OnboardingIllustrationPlaceholder extends StatelessWidget {
  const OnboardingIllustrationPlaceholder({
    super.key,
    required this.name,
    this.height = 220,
  });

  final String name;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Margins.spacingBase),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: Dimens.strokeWidthS,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacingBase),
        child: Text(
          '[ILLUSTRATION] $name',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
