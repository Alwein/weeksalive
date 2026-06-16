import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_installer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Bottom sheet shown on iOS after rendering the wallpaper PNG. iOS has no
/// public wallpaper API, so we guide the user to build a one-time Shortcut that
/// chains our "Get Wallpaper" App Intent into the system Set Wallpaper action,
/// then run it on a schedule.
class WallpaperIosHelpSheet extends StatelessWidget {
  const WallpaperIosHelpSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.radiusL)),
      ),
      builder: (_) => StoreProvider<AppState>(
        store: StoreProvider.of<AppState>(context, listen: false),
        child: const WallpaperIosHelpSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Texts.xlBold(Strings.wallpaperIosHelpTitle),
            const SizedBox(height: Margins.spacingBase),
            Texts.primaryRegularMedium(Strings.wallpaperIosHelpBody, color: AppColors.contentSoft(context)),
            const SizedBox(height: Margins.spacingM),
            _Step(index: 1, text: Strings.wallpaperIosHelpStep1),
            _Step(index: 2, text: Strings.wallpaperIosHelpStep2),
            _Step(index: 3, text: Strings.wallpaperIosHelpStep3),
            _Step(index: 4, text: Strings.wallpaperIosHelpStep4),
            _Step(index: 5, text: Strings.wallpaperIosHelpStep5),
            const SizedBox(height: Margins.spacingBase),
            Texts.primaryRegularMedium(Strings.wallpaperIosHelpNote, color: AppColors.contentSoft(context)),
            const SizedBox(height: Margins.spacingM),
            PrimaryButton(
              text: Strings.wallpaperOpenShortcuts,
              onPressed: () => WallpaperInstaller().openShortcutsApp(),
            ),
            const SizedBox(height: Margins.spacingBase),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.text});
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacingBase),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.content(context),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(color: AppColors.bg(context), fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          Expanded(child: Texts.primaryRegularMedium(text)),
        ],
      ),
    );
  }
}
