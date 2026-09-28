import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/core/styles/app_theme_builder.dart';
import 'package:weeksalive/core/styles/app_theme_id.dart';
import 'package:weeksalive/presentation/wallpaper/demo_shortcut_player.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_demo_video_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('opening Shortcuts resumes the demo in the mini player', () async {
    final api = _FakePlayer();
    final controller = DemoShortcutPlayerController();
    controller.attach(api);

    await controller.playInMiniPlayer();

    expect(api.calls, ['play', 'pip']);
  });

  test('does nothing when the demo player is not on screen', () async {
    final controller = DemoShortcutPlayerController();

    await controller.playInMiniPlayer();
  });

  test('ignores a player that has left the screen', () async {
    final api = _FakePlayer();
    final controller = DemoShortcutPlayerController();
    controller.attach(api);
    controller.detach(api);

    await controller.playInMiniPlayer();

    expect(api.calls, isEmpty);
  });

  testWidgets('shows the demo and a play button until it is playing', (
    tester,
  ) async {
    var toggles = 0;
    await _pumpCard(tester, onTogglePlayback: () => toggles++);

    expect(find.text('See it in action'), findsOneWidget);
    expect(find.text('It stays with you in Shortcuts.'), findsOneWidget);
    expect(find.byKey(WallpaperDemoVideoCard.playKey), findsOneWidget);

    await tester.tap(find.byKey(WallpaperDemoVideoCard.playKey));
    await tester.pump();

    expect(toggles, 1);
  });

  testWidgets('offers the mini player once playback has started', (
    tester,
  ) async {
    var pipStarts = 0;
    await _pumpCard(
      tester,
      isPlaying: true,
      pipSupported: true,
      onStartPip: () => pipStarts++,
    );

    expect(find.byKey(WallpaperDemoVideoCard.playKey), findsNothing);
    expect(find.byKey(WallpaperDemoVideoCard.pipKey), findsOneWidget);

    await tester.tap(find.byKey(WallpaperDemoVideoCard.pipKey));
    await tester.pump();

    expect(pipStarts, 1);
  });

  testWidgets('explains that the demo moved to the mini player', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      isPlaying: true,
      isPipActive: true,
      pipSupported: true,
    );

    expect(find.byKey(WallpaperDemoVideoCard.pipActiveKey), findsOneWidget);
    expect(find.text('Playing in the mini player'), findsOneWidget);
    expect(find.byKey(WallpaperDemoVideoCard.playKey), findsNothing);
    expect(find.byKey(WallpaperDemoVideoCard.pipKey), findsNothing);
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  bool isReady = true,
  bool isPlaying = false,
  bool isPipActive = false,
  bool pipSupported = false,
  VoidCallback? onTogglePlayback,
  VoidCallback? onStartPip,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppThemeBuilder.build(AppThemeId.light).theme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: WallpaperDemoVideoCard(
            video: const ColoredBox(color: Colors.black),
            title: 'See it in action',
            caption: 'It stays with you in Shortcuts.',
            pipActiveLabel: 'Playing in the mini player',
            playLabel: 'Play',
            pauseLabel: 'Pause',
            pipLabel: 'Mini player',
            isReady: isReady,
            hasError: false,
            isPlaying: isPlaying,
            isPipActive: isPipActive,
            pipSupported: pipSupported,
            progress: 0.2,
            onTogglePlayback: onTogglePlayback ?? () {},
            onStartPip: onStartPip ?? () {},
            onStopPip: () {},
            onSeek: (_) {},
          ),
        ),
      ),
    ),
  );
}

class _FakePlayer implements DemoShortcutPlayerApi {
  final calls = <String>[];

  @override
  Future<void> play() async => calls.add('play');

  @override
  Future<bool> startPictureInPicture() async {
    calls.add('pip');
    return true;
  }
}
