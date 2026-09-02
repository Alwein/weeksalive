import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// One-time nudge, shown on the second app launch, inviting users who have not
/// set up the automatic wallpaper yet to do so.
///
/// Resolves to `true` when the user taps the call to action, `false` (or `null`)
/// when they dismiss it.
class WallpaperPromptSheet extends StatelessWidget {
  const WallpaperPromptSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showCustomBottomSheet<bool>(
      context,
      (context) => const WallpaperPromptSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _WallpaperIllustration(),
          const SizedBox(height: Margins.spacingM),
          Texts.xlBold(Strings.wallpaperPromptTitle),
          const SizedBox(height: Margins.spacingS),
          Texts.primaryMediumSoft(context, Strings.wallpaperPromptBody),
          const SizedBox(height: Margins.spacingM),
          PrimaryButton(
            text: Strings.wallpaperPromptCta,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: Margins.spacingS),
          SecondaryButton(
            text: Strings.wallpaperPromptDismiss,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

/// Lock-screen mockup, with the bottom 10% faded out so the image blends into
/// the sheet instead of ending on a hard edge.
class _WallpaperIllustration extends StatelessWidget {
  const _WallpaperIllustration();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.radiusL)),
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.9, 1.0],
          colors: [Colors.black, Colors.transparent],
        ).createShader(bounds),
        child: Image.asset(
          'assets/images/wallpaper_illustration.webp',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
