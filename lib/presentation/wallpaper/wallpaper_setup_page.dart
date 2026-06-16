import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weeksalive/core/constants/wallpaper_constants.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_installer.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_type.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Full setup guide for iOS Shortcuts automation (shown from the editor).
class WallpaperSetupPage extends StatelessWidget {
  const WallpaperSetupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const WallpaperSetupPage());
  }

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    final gridType = StoreProvider.of<AppState>(context, listen: false).state.wallpaperState.config.gridType;
    final automationBody = gridType == WallpaperGridType.life
        ? Strings.wallpaperSetupAutomationBodyLife
        : Strings.wallpaperSetupAutomationBodyYear;

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.wallpaperSetupTitle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Texts.primaryRegularMedium(Strings.wallpaperSetupSubtitle, color: AppColors.contentSoft(context)),
              const SizedBox(height: Margins.spacingL),
              Texts.primaryBold(Strings.wallpaperSetupShortcutTitle),
              const SizedBox(height: Margins.spacingBase),
              Texts.primaryRegularMedium(Strings.wallpaperSetupShortcutBody),
              const SizedBox(height: Margins.spacingBase),
              PrimaryButton(
                text: Strings.wallpaperOpenShortcuts,
                onPressed: () => WallpaperInstaller().openShortcutsApp(),
              ),
              const SizedBox(height: Margins.spacingL),
              Texts.primaryBold(Strings.wallpaperSetupAutomationTitle),
              const SizedBox(height: Margins.spacingBase),
              Texts.primaryRegularMedium(automationBody),
              const Spacer(),
              Texts.primaryBold(Strings.wallpaperSetupTestTitle),
              const SizedBox(height: Margins.spacingBase),
              PrimaryButton(
                text: Strings.wallpaperSetupTestButton,
                onPressed: () => _openUrl(WallpaperConstants.runShortcutUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
