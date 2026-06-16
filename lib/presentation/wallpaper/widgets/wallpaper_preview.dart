import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
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
    this.maxHeight = 420,
  });

  final WallpaperConfig config;
  final WallpaperGridData data;
  final AppColorTokens tokens;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    const phoneAspect = 390.0 / 844.0;
    final width = maxHeight * phoneAspect;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: width,
          height: maxHeight,
          child: FittedBox(
            fit: BoxFit.cover,
            child: WallpaperView(
              config: config,
              data: data,
              tokens: tokens,
              size: const Size(390, 844),
            ),
          ),
        ),
      ),
    );
  }
}
