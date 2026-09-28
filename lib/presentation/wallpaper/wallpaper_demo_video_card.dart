import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Phone-framed demo shown above the wallpaper Shortcuts steps.
class WallpaperDemoVideoCard extends StatelessWidget {
  const WallpaperDemoVideoCard({
    super.key,
    required this.video,
    required this.title,
    required this.caption,
    required this.pipActiveLabel,
    required this.playLabel,
    required this.pauseLabel,
    required this.pipLabel,
    required this.isReady,
    required this.hasError,
    required this.isPlaying,
    required this.isPipActive,
    required this.pipSupported,
    required this.progress,
    required this.onTogglePlayback,
    required this.onStartPip,
    required this.onStopPip,
    required this.onSeek,
  });

  static const videoTapKey = Key('wallpaper_demo_video_tap');
  static const playKey = Key('wallpaper_demo_play');
  static const pipKey = Key('wallpaper_demo_pip');
  static const pipActiveKey = Key('wallpaper_demo_pip_active');

  final Widget video;
  final String title;
  final String caption;
  final String pipActiveLabel;
  final String playLabel;
  final String pauseLabel;
  final String pipLabel;
  final bool isReady;
  final bool hasError;
  final bool isPlaying;
  final bool isPipActive;
  final bool pipSupported;
  final double progress;
  final VoidCallback onTogglePlayback;
  final VoidCallback onStartPip;
  final VoidCallback onStopPip;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 260.0;
        final videoWidth = math.min(260.0, maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  MingCuteIcons.mgc_video_line,
                  size: Dimens.iconSizeS,
                  color: AppColors.contentSoft(context),
                ),
                const SizedBox(width: Margins.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.primaryMediumBlack.copyWith(
                      color: AppColors.content(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryRegularMedium(
              caption,
              color: AppColors.contentSoft(context),
            ),
            const SizedBox(height: Margins.spacingBase),
            Center(
              child: SizedBox(
                width: videoWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    border: Border.all(color: AppColors.strokeColor(context)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.radiusXl),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: _VideoFrame(
                        video: video,
                        isReady: isReady,
                        hasError: hasError,
                        isPlaying: isPlaying,
                        isPipActive: isPipActive,
                        pipSupported: pipSupported,
                        progress: progress,
                        pipActiveLabel: pipActiveLabel,
                        playLabel: playLabel,
                        pauseLabel: pauseLabel,
                        pipLabel: pipLabel,
                        onTogglePlayback: onTogglePlayback,
                        onStartPip: onStartPip,
                        onStopPip: onStopPip,
                        onSeek: onSeek,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VideoFrame extends StatelessWidget {
  const _VideoFrame({
    required this.video,
    required this.isReady,
    required this.hasError,
    required this.isPlaying,
    required this.isPipActive,
    required this.pipSupported,
    required this.progress,
    required this.pipActiveLabel,
    required this.playLabel,
    required this.pauseLabel,
    required this.pipLabel,
    required this.onTogglePlayback,
    required this.onStartPip,
    required this.onStopPip,
    required this.onSeek,
  });

  final Widget video;
  final bool isReady;
  final bool hasError;
  final bool isPlaying;
  final bool isPipActive;
  final bool pipSupported;
  final double progress;
  final String pipActiveLabel;
  final String playLabel;
  final String pauseLabel;
  final String pipLabel;
  final VoidCallback onTogglePlayback;
  final VoidCallback onStartPip;
  final VoidCallback onStopPip;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    final showPlay = isReady && !hasError && !isPlaying && !isPipActive;
    final showPipButton = isReady && !hasError && pipSupported && !isPipActive;
    final showProgress = isReady && !hasError && !isPipActive;

    return Stack(
      fit: StackFit.expand,
      children: [
        Semantics(
          button: isReady && !hasError,
          label: isPipActive
              ? pipActiveLabel
              : (isPlaying ? pauseLabel : playLabel),
          child: GestureDetector(
            key: WallpaperDemoVideoCard.videoTapKey,
            behavior: HitTestBehavior.opaque,
            onTap: isPipActive
                ? onStopPip
                : (isReady && !hasError ? onTogglePlayback : null),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Colors.black),
                video,
                if (showProgress)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x59000000)],
                        ),
                      ),
                    ),
                  ),
                if (!isReady && !hasError)
                  const Center(child: _LoadingIndicator()),
                if (hasError)
                  const Center(
                    child: Icon(
                      MingCuteIcons.mgc_video_line,
                      color: Colors.white,
                      size: Dimens.iconSizeM,
                    ),
                  ),
                if (isPipActive)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Margins.spacingBase,
                      ),
                      child: Column(
                        key: WallpaperDemoVideoCard.pipActiveKey,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.picture_in_picture_alt_outlined,
                            color: Colors.white,
                            size: Dimens.iconSizeM,
                          ),
                          const SizedBox(height: Margins.spacingS),
                          Text(
                            pipActiveLabel,
                            textAlign: TextAlign.center,
                            style: TextStyles.primaryRegularMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showPlay)
                  Center(
                    child: Container(
                      key: WallpaperDemoVideoCard.playKey,
                      width: Dimens.iconSizeHuge,
                      height: Dimens.iconSizeHuge,
                      decoration: const BoxDecoration(
                        color: Color(0x73000000),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Icon(
                          MingCuteIcons.mgc_play_fill,
                          color: Colors.white,
                          size: Dimens.iconSizeM,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (showProgress)
          Positioned(
            left: Margins.spacingBase,
            right: Margins.spacingBase,
            bottom: Margins.spacingBase,
            child: _ProgressBar(progress: progress, onSeek: onSeek),
          ),
        if (showPipButton)
          Positioned(
            top: Margins.spacingS,
            right: Margins.spacingS,
            child: Tooltip(
              message: pipLabel,
              child: Material(
                color: const Color(0x73000000),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: WallpaperDemoVideoCard.pipKey,
                  customBorder: const CircleBorder(),
                  onTap: onStartPip,
                  child: Semantics(
                    button: true,
                    label: pipLabel,
                    child: const Padding(
                      padding: EdgeInsets.all(Margins.spacingS),
                      child: Icon(
                        Icons.picture_in_picture_alt_outlined,
                        color: Colors.white,
                        size: Dimens.iconSizeS,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: Dimens.iconSizeBase,
      height: Dimens.iconSizeBase,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.onSeek});

  final double progress;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              onSeek(_fraction(details.localPosition.dx, constraints.maxWidth)),
          onHorizontalDragUpdate: (details) =>
              onSeek(_fraction(details.localPosition.dx, constraints.maxWidth)),
          child: SizedBox(
            height: 18,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radiusXs),
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    backgroundColor: const Color(0x40FFFFFF),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _fraction(double dx, double width) {
    if (width <= 0) return 0;
    return (dx / width).clamp(0, 1);
  }
}
