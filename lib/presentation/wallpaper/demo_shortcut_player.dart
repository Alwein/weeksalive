import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_demo_video_card.dart';

/// Talks to the iOS demo player. [playInMiniPlayer] resumes playback and
/// asks the system to detach it into Picture in Picture.
abstract class DemoShortcutPlayerApi {
  Future<void> play();
  Future<bool> startPictureInPicture();
}

class DemoShortcutPlayerController {
  DemoShortcutPlayerApi? _api;

  void attach(DemoShortcutPlayerApi api) => _api = api;

  void detach(DemoShortcutPlayerApi api) {
    if (identical(_api, api)) _api = null;
  }

  /// Keeps the demo visible over Shortcuts. No-ops when the player is gone.
  Future<void> playInMiniPlayer() async {
    final api = _api;
    if (api == null) return;
    await api.play();
    await api.startPictureInPicture();
  }
}

/// Wallpaper Shortcuts demo. Plays inline, and moves to the iOS mini player
/// when the guide opens Shortcuts.
class WallpaperDemoVideo extends StatefulWidget {
  const WallpaperDemoVideo({super.key, required this.controller});

  final DemoShortcutPlayerController controller;

  @override
  State<WallpaperDemoVideo> createState() => _WallpaperDemoVideoState();
}

class _WallpaperDemoVideoState extends State<WallpaperDemoVideo>
    implements DemoShortcutPlayerApi {
  static const _viewType = 'weeksalive/demo_shortcut_player';
  static const _asset = 'assets/videos/demo_shortcut.mp4';

  MethodChannel? _channel;
  StreamSubscription<dynamic>? _events;
  bool? _autoplay;
  bool _isReady = false;
  bool _hasError = false;
  bool _isPlaying = false;
  bool _isPipActive = false;
  bool _pipSupported = false;
  int _durationMs = 0;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.attach(this);
  }

  @override
  void didUpdateWidget(WallpaperDemoVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detach(this);
      widget.controller.attach(this);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _autoplay ??= !MediaQuery.disableAnimationsOf(context);
  }

  @override
  void dispose() {
    widget.controller.detach(this);
    _events?.cancel();
    super.dispose();
  }

  @override
  Future<void> play() async {
    await _channel?.invokeMethod<void>('play');
  }

  @override
  Future<bool> startPictureInPicture() async {
    final started = await _channel?.invokeMethod<bool>('startPictureInPicture');
    return started ?? false;
  }

  void _onViewCreated(int id) {
    _channel = MethodChannel('com.weeksalive/demo_shortcut_player/$id');
    _events = EventChannel(
      'com.weeksalive/demo_shortcut_player/$id/events',
    ).receiveBroadcastStream().listen(_onEvent, onError: (_) {});
  }

  void _onEvent(dynamic event) {
    if (event is! Map || !mounted) return;
    final map = Map<Object?, Object?>.from(event);
    final durationMs = (map['durationMs'] as num?)?.toInt() ?? 0;
    final positionMs = (map['positionMs'] as num?)?.toInt() ?? 0;
    setState(() {
      _isReady = map['isReady'] == true;
      _hasError = map['hasError'] == true;
      _isPlaying = map['isPlaying'] == true;
      _isPipActive = map['isPipActive'] == true;
      _pipSupported = map['pipSupported'] == true;
      _durationMs = durationMs;
      _progress = durationMs > 0 ? (positionMs / durationMs).clamp(0, 1) : 0;
    });
  }

  Future<void> _togglePlayback() async {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      await play();
    } else {
      await _channel?.invokeMethod<void>('pause');
    }
  }

  Future<void> _startPip() async {
    setState(() => _isPlaying = true);
    await play();
    final started = await startPictureInPicture();
    if (!mounted) return;
    if (started) setState(() => _isPipActive = true);
  }

  Future<void> _stopPip() async {
    await _channel?.invokeMethod<void>('stopPictureInPicture');
  }

  void _seek(double fraction) {
    if (_durationMs <= 0) return;
    final positionMs = (_durationMs * fraction).round();
    setState(() => _progress = fraction.clamp(0, 1));
    _channel?.invokeMethod<void>('seek', {'positionMs': positionMs});
  }

  @override
  Widget build(BuildContext context) {
    return WallpaperDemoVideoCard(
      title: Strings.wallpaperSetupDemoTitle,
      caption: Strings.wallpaperSetupDemoCaption,
      pipActiveLabel: Strings.wallpaperSetupDemoPipActive,
      playLabel: Strings.wallpaperSetupDemoPlay,
      pauseLabel: Strings.wallpaperSetupDemoPause,
      pipLabel: Strings.wallpaperSetupDemoPip,
      isReady: _isReady,
      hasError: _hasError,
      isPlaying: _isPlaying,
      isPipActive: _isPipActive,
      pipSupported: _pipSupported,
      progress: _progress,
      onTogglePlayback: _togglePlayback,
      onStartPip: _startPip,
      onStopPip: _stopPip,
      onSeek: _seek,
      video: UiKitView(
        key: const ValueKey(_viewType),
        viewType: _viewType,
        creationParams: {'asset': _asset, 'autoplay': _autoplay ?? true},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onViewCreated,
      ),
    );
  }
}

/// Guards the platform view so tests and non-iOS builds never construct it.
class WallpaperDemoVideoSlot extends StatelessWidget {
  const WallpaperDemoVideoSlot({super.key, required this.controller});

  final DemoShortcutPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) return const SizedBox.shrink();
    return WallpaperDemoVideo(controller: controller);
  }
}
