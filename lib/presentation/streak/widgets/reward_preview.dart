import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_catalog.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_renderer.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/themes/app_theme.dart';
import 'package:weeksalive/domain/rewards/reward_display.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/profile/pages/app_icon_picker/app_icon_picker_page.dart';
import 'package:weeksalive/presentation/profile/pages/grid_motif_picker/grid_motif_picker_page.dart';
import 'package:weeksalive/presentation/profile/pages/theme_picker/theme_picker_page.dart';

void openRewardPicker(BuildContext context, RewardId rewardId) {
  final navigator = Navigator.of(context, rootNavigator: true);
  navigator.pop();
  if (rewardId.previewThemeId != null) {
    navigator.push(ThemePickerPage.route());
    return;
  }
  if (rewardId.previewAppIconId != null) {
    navigator.push(AppIconPickerPage.route());
    return;
  }
  if (rewardId.previewGridMotifId != null) {
    navigator.push(GridMotifPickerPage.route());
  }
}

class RewardPreview extends StatelessWidget {
  const RewardPreview({
    super.key,
    required this.rewardId,
    this.locked = false,
  });

  final RewardId rewardId;

  /// Affiche un cadenas et rend l'aperçu non interactif pour une récompense
  /// pas encore débloquée.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimens.radiusBase),
      onTap: locked ? null : () => openRewardPicker(context, rewardId),
      child: RewardPreviewContent(rewardId: rewardId, locked: locked),
    );
  }
}

class RewardPreviewContent extends StatelessWidget {
  const RewardPreviewContent({
    super.key,
    required this.rewardId,
    this.locked = false,
  });

  final RewardId rewardId;

  /// Superpose un cadenas et atténue l'aperçu pour signaler qu'il est verrouillé.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    if (locked) {
      return _LockedRewardPreview(
        child: RewardPreviewContent(rewardId: rewardId),
      );
    }

    final themeId = rewardId.previewThemeId;
    if (themeId != null) {
      return _ThemeRewardPreview(themeId: themeId, label: rewardId.label);
    }

    final iconId = rewardId.previewAppIconId;
    if (iconId != null) {
      return _AppIconRewardPreview(iconId: iconId);
    }

    final motifId = rewardId.previewGridMotifId;
    if (motifId != null) {
      return _GridMotifRewardPreview(motifId: motifId);
    }

    return const SizedBox.shrink();
  }
}

/// Enveloppe un aperçu de récompense avec un voile et un cadenas centré pour
/// indiquer clairement qu'elle n'est pas encore débloquée.
class _LockedRewardPreview extends StatelessWidget {
  const _LockedRewardPreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.6,
          child: IgnorePointer(child: child),
        ),
        Container(
          padding: const EdgeInsets.all(Margins.spacingS),
          decoration: BoxDecoration(
            color: AppColors.bg(context).withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            MingCuteIcons.mgc_lock_line,
            size: Dimens.iconSizeS,
            color: AppColors.content(context),
          ),
        ),
      ],
    );
  }
}

class _ThemeRewardPreview extends StatelessWidget {
  const _ThemeRewardPreview({required this.themeId, required this.label});

  final AppThemeId themeId;
  final String label;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppThemes.of(themeId);
    final tokens = appTheme.isDynamic ? appTheme.lightTokens! : appTheme.tokens!;

    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      decoration: BoxDecoration(
        color: tokens.bg,
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        border: Border.all(color: tokens.strokeColor, width: Dimens.strokeWidthBase),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ThemeMiniPreview(tokens: tokens),
        ],
      ),
    );
  }
}

class _ThemeMiniPreview extends StatelessWidget {
  const _ThemeMiniPreview({required this.tokens});

  final AppColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniWeekGrid(tokens: tokens),
        const SizedBox(width: Margins.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              _FakeLine(widthFraction: 0.9, height: 12, color: tokens.content),
              _FakeLine(widthFraction: 0.7, height: 6, color: tokens.contentSoft),
              _FakeLine(widthFraction: 0.55, height: 6, color: tokens.contentSoft),
              _FakeLine(widthFraction: 0.8, height: 4, color: tokens.contentExtraSoft),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniWeekGrid extends StatelessWidget {
  const _MiniWeekGrid({required this.tokens});

  final AppColorTokens tokens;

  static const _rows = 4;
  static const _cols = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Margins.spacingXs,
      children: [
        for (var r = 0; r < _rows; r++)
          Row(
            spacing: Margins.spacingXs,
            children: [
              for (var c = 0; c < _cols; c++)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: r == 0 && c == 0 ? tokens.content : (r < 2 ? tokens.contentExtraSoft : Colors.transparent),
                    shape: BoxShape.circle,
                    border: r < 2 ? null : Border.all(color: tokens.strokeColor, width: Dimens.strokeWidthS),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _FakeLine extends StatelessWidget {
  const _FakeLine({
    required this.widthFraction,
    required this.height,
    required this.color,
  });

  static const _referenceWidth = 96.0;

  final double widthFraction;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _referenceWidth * widthFraction,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class _AppIconRewardPreview extends StatelessWidget {
  const _AppIconRewardPreview({required this.iconId});

  final AppIconId iconId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.radiusBase),
            boxShadow: [
              BoxShadow(
                color: AppColors.contentSoft(context).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          child: Image.asset(
            iconId.illustrationAsset,
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _GridMotifRewardPreview extends StatelessWidget {
  const _GridMotifRewardPreview({required this.motifId});

  final GridMotifId motifId;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(Margins.spacingBase),
        decoration: BoxDecoration(
          color: AppColors.contentMuted(context),
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
          border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              width: width,
              height: width * 0.075,
              child: CustomPaint(
                painter: _GridMotifPreviewPainter(
                  motifId: motifId,
                  fillColor: AppColors.content(context),
                  emptyStrokeColor: AppColors.strokeColor(context),
                  pastEmptyColor: AppColors.contentSoftOnSoft(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GridMotifPreviewPainter extends CustomPainter {
  const _GridMotifPreviewPainter({
    required this.motifId,
    required this.fillColor,
    required this.emptyStrokeColor,
    required this.pastEmptyColor,
  });

  static const _columns = 12;
  static const _spacing = 3.0;
  static const _minDotDiameter = 4.0;
  static const _previewFillSizes = [0, 1, 2, 3, 4, -2, -1];

  final GridMotifId motifId;
  final Color fillColor;
  final Color emptyStrokeColor;
  final Color pastEmptyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - _spacing * (_columns - 1)) / _columns;
    final maxRadius = dotSize / 2;
    final cellCount = _previewFillSizes.length;
    final contentWidth = cellCount * dotSize + _spacing * (cellCount - 1);
    final horizontalOffset = (size.width - contentWidth) / 2;
    final verticalOffset = (size.height - dotSize) / 2;

    for (var i = 0; i < _previewFillSizes.length; i++) {
      final fillSize = _previewFillSizes[i];
      final rect = GridMotifRenderer.cellRect(
        padding: EdgeInsets.only(left: horizontalOffset, top: verticalOffset),
        columns: _columns,
        dotSpacing: _spacing,
        dotSize: dotSize,
        index: i,
      );
      final appearance = _appearanceForFillSize(fillSize: fillSize, maxRadius: maxRadius);
      GridMotifRenderer.draw(
        canvas: canvas,
        motifId: motifId,
        variant: gridCellVariantForYearFillSize(fillSize),
        cellIndex: i,
        rect: rect,
        color: appearance.color,
        scale: appearance.scale,
        isStroke: appearance.isStroke,
      );
    }
  }

  ({double scale, Color color, bool isStroke}) _appearanceForFillSize({
    required int fillSize,
    required double maxRadius,
  }) {
    return switch (fillSize) {
      -1 => (scale: 1.0, color: emptyStrokeColor, isStroke: true),
      -2 => (scale: 1.0, color: pastEmptyColor, isStroke: false),
      _ => (
        scale: _noteScale(fillSize.clamp(0, 4), maxRadius),
        color: fillColor,
        isStroke: false,
      ),
    };
  }

  double _sizeRadius(int level, double maxRadius) {
    const minRadius = _minDotDiameter / 2;
    if (level <= 0) return minRadius;
    if (level >= 4) return maxRadius;
    return minRadius + (maxRadius - minRadius) * (level / 4);
  }

  double _noteScale(int level, double maxRadius) {
    if (GridMotifCatalog.forId(motifId).uniformYearNoteSize) return 1.0;
    return _sizeRadius(level, maxRadius) / maxRadius;
  }

  @override
  bool shouldRepaint(covariant _GridMotifPreviewPainter old) =>
      old.motifId != motifId ||
      old.fillColor != fillColor ||
      old.emptyStrokeColor != emptyStrokeColor ||
      old.pastEmptyColor != pastEmptyColor;
}
