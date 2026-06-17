import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_config.dart';
import 'package:weeksalive/domain/wallpaper/wallpaper_grid_data.dart';
import 'package:weeksalive/presentation/wallpaper/widgets/wallpaper_view.dart';

/// Result of a wallpaper render: the PNG bytes plus the absolute file path they
/// were written to.
class RenderedWallpaper {
  const RenderedWallpaper({required this.bytes, required this.filePath});

  final Uint8List bytes;
  final String filePath;
}

/// Renders a [WallpaperView] off-screen into a full-resolution PNG.
///
/// The widget is built and laid out through a standalone render pipeline
/// (`BuildOwner` + `PipelineOwner` + [RenderRepaintBoundary]) so it does not
/// need to be attached to the live widget tree. The resulting bitmap is sized
/// to the physical screen so it can be installed verbatim as a wallpaper.
class WallpaperRenderer {
  WallpaperRenderer();

  /// iOS App Group used to expose the PNG to the widget extension / Shortcuts.
  static const appGroupId = 'group.com.weeksalive';

  /// File name of the generated wallpaper in the app documents dir / App Group.
  static const wallpaperFileName = 'weeksalive_wallpaper.png';

  /// Renders [config]/[data] at [logicalSize] (points) and [pixelRatio]
  /// (device pixel ratio), writes the PNG to disk and returns it.
  Future<RenderedWallpaper> render({
    required WallpaperConfig config,
    required WallpaperGridData data,
    required AppColorTokens tokens,
    AppColorTokens? gridTokens,
    required Size logicalSize,
    required double pixelRatio,
  }) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final bytes = await _capture(
      config: config,
      data: data,
      tokens: tokens,
      gridTokens: gridTokens,
      logicalSize: logicalSize,
      pixelRatio: pixelRatio,
      documentsDirectoryPath: documentsDir.path,
    );
    final filePath = await _writeToDisk(bytes);
    return RenderedWallpaper(bytes: bytes, filePath: filePath);
  }

  Future<Uint8List> _capture({
    required WallpaperConfig config,
    required WallpaperGridData data,
    required AppColorTokens tokens,
    AppColorTokens? gridTokens,
    required Size logicalSize,
    required double pixelRatio,
    required String documentsDirectoryPath,
  }) async {
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.implicitView ??
        WidgetsBinding.instance.platformDispatcher.views.first;

    final renderView = RenderView(
      view: view,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
        devicePixelRatio: 1.0,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: WallpaperView(
          config: config,
          data: data,
          tokens: tokens,
          gridTokens: gridTokens,
          size: logicalSize,
          documentsDirectoryPath: documentsDirectoryPath,
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image? image;
    try {
      image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw StateError('Failed to encode wallpaper PNG');
      }
      return byteData.buffer.asUint8List();
    } finally {
      image?.dispose();
      pipelineOwner.rootNode = null;
    }
  }

  /// Writes [bytes] to the shared App Group container on iOS (so the Shortcuts
  /// automation / app extension can read it) and to the documents dir on
  /// Android. Returns the absolute path written.
  Future<String> _writeToDisk(Uint8List bytes) async {
    Directory dir;
    if (Platform.isIOS) {
      final containerPath = await PathProviderFoundation().getContainerPath(
        appGroupIdentifier: appGroupId,
      );
      dir = containerPath != null ? Directory(containerPath) : await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    final file = File(p.join(dir.path, wallpaperFileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
