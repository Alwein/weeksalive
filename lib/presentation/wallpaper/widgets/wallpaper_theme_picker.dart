import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';
import 'package:weeksalive/presentation/widgets/theme_picker.dart';

class WallpaperThemePicker extends StatelessWidget {
  const WallpaperThemePicker({
    super.key,
    required this.selectedThemeId,
    required this.onSelected,
  });

  final AppThemeId selectedThemeId;
  final ValueChanged<AppThemeId> onSelected;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Set<AppThemeId>>(
      converter: (store) => store.state.themeState.unlockedThemes,
      builder: (context, unlockedThemes) {
        final themes = AppThemeId.all.where((id) => id != AppThemeId.system).where(unlockedThemes.contains).toList();
        return Wrap(
          spacing: Margins.spacingBase,
          runSpacing: Margins.spacingBase,
          children: [
            for (final themeId in themes)
              _WallpaperThemeSwatch(
                themeId: themeId,
                selected: themeId == selectedThemeId,
                onTap: () {
                  SensorialFeedback.selectionChanged();
                  onSelected(themeId);
                },
              ),
          ],
        );
      },
    );
  }
}

class _WallpaperThemeSwatch extends StatelessWidget {
  const _WallpaperThemeSwatch({
    required this.themeId,
    required this.selected,
    required this.onTap,
  });

  final AppThemeId themeId;
  final bool selected;
  final VoidCallback onTap;

  static const _swatchSize = 32.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(Margins.spacingBase),
        decoration: BoxDecoration(
          color: selected ? AppColors.content(context) : AppColors.bgSoft(context),
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
        ),
        child: Column(
          children: [
            SizedBox(
              width: _swatchSize,
              height: _swatchSize,
              child: ClipOval(child: _ThemeSwatchFill(themeId: themeId)),
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryXsMedium(
              themeId.label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              color: selected ? AppColors.contentMuted(context) : AppColors.content(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSwatchFill extends StatelessWidget {
  const _ThemeSwatchFill({required this.themeId});

  final AppThemeId themeId;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppThemes.of(themeId).previewColor);
  }
}
