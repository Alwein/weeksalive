import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:weeksalive/data/wallpaper/wallpaper_background_image_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wallpaper_bg_test_');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('normalizeStoredValue', () {
    test('returns bare file names unchanged', () {
      expect(
        WallpaperBackgroundImageStorage.normalizeStoredValue('wallpaper_bg_123.jpeg'),
        'wallpaper_bg_123.jpeg',
      );
    });

    test('strips directory from legacy absolute paths', () {
      expect(
        WallpaperBackgroundImageStorage.normalizeStoredValue(
          '/var/mobile/Documents/wallpaper_bg_123.jpeg',
        ),
        'wallpaper_bg_123.jpeg',
      );
    });
  });

  group('resolveSync', () {
    test('resolves a file name inside documents directory', () async {
      final file = File(p.join(tempDir.path, 'wallpaper_bg_42.jpg'));
      await file.writeAsBytes([1, 2, 3]);

      final resolved = WallpaperBackgroundImageStorage.resolveSync(
        'wallpaper_bg_42.jpg',
        tempDir.path,
      );

      expect(resolved, file.path);
    });

    test('resolves legacy absolute paths via basename in documents directory', () async {
      final file = File(p.join(tempDir.path, 'wallpaper_bg_legacy.png'));
      await file.writeAsBytes([4, 5, 6]);

      final resolved = WallpaperBackgroundImageStorage.resolveSync(
        '/old/container/path/wallpaper_bg_legacy.png',
        tempDir.path,
      );

      expect(resolved, file.path);
    });

    test('returns null when the file does not exist', () {
      expect(
        WallpaperBackgroundImageStorage.resolveSync('missing.jpg', tempDir.path),
        isNull,
      );
    });
  });
}
