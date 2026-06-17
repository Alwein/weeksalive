import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_view.dart';

/// Scaled-down live preview of the wallpaper inside the editor.
class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({
    super.key,
    required this.config,
    required this.data,
    required this.tokens,
    this.gridTokens,
    this.maxHeight = 420,
    this.documentsDirectoryPath,
  });

  final WallpaperConfig config;
  final WallpaperGridData data;
  final AppColorTokens tokens;
  final AppColorTokens? gridTokens;
  final double maxHeight;
  final String? documentsDirectoryPath;

  static const _mockupReference = Size(402, 874);
  static const _phoneReferenceHeight = 844.0;
  static const _dateOverlayReference = Size(215, 116);
  static const _dateOverlayTop = 80.0;
  static const _dateOverlayAsset = 'assets/images/date_wallpaper.svg';

  @override
  Widget build(BuildContext context) {
    const phoneAspect = 390.0 / 844.0;
    final width = maxHeight * phoneAspect;
    final height = maxHeight;
    final scale = height / _phoneReferenceHeight;
    final outerRadius = 60 * scale;
    final strokeWidth = Dimens.strokeWidthBase * scale;
    final innerRadius = outerRadius - strokeWidth;
    final overlayWidth = width * (_dateOverlayReference.width / _mockupReference.width);
    final overlayHeight = height * (_dateOverlayReference.height / _mockupReference.height);
    final overlayLeft = (width - overlayWidth) / 2;
    final overlayTop = height * (_dateOverlayTop / _mockupReference.height);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        border: Border.all(
          color: AppColors.strokeColor(context),
          width: strokeWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(strokeWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: WallpaperView(
                    config: config,
                    data: data,
                    tokens: tokens,
                    gridTokens: gridTokens,
                    size: const Size(390, 844),
                    documentsDirectoryPath: documentsDirectoryPath,
                  ),
                ),
                if (Platform.isIOS)
                  Positioned(
                    left: overlayLeft,
                    top: overlayTop,
                    width: overlayWidth,
                    height: overlayHeight,
                    child: IgnorePointer(
                      child: SvgPicture.asset(
                        _dateOverlayAsset,
                        fit: BoxFit.fill,
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
