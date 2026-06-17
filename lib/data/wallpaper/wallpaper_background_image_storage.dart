import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists user-picked wallpaper backgrounds under the app documents directory.
///
/// [WallpaperConfig.backgroundImagePath] stores the returned file name only so
/// the path survives iOS sandbox container changes and app updates.
abstract final class WallpaperBackgroundImageStorage {
  static Future<String> saveFromPicker(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'wallpaper_bg_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final dest = p.join(appDir.path, fileName);
    await File(sourcePath).copy(dest);
    return fileName;
  }

  /// Resolves a stored file name (or legacy absolute path) to an absolute path
  /// when the file exists; otherwise returns null.
  static String? resolveSync(String? stored, String documentsDirectoryPath) {
    if (stored == null || stored.isEmpty) return null;

    final candidates = <String>[];
    if (stored.contains('/')) {
      candidates.add(p.join(documentsDirectoryPath, p.basename(stored)));
      candidates.add(stored);
    } else {
      candidates.add(p.join(documentsDirectoryPath, stored));
    }

    for (final path in candidates) {
      if (File(path).existsSync()) return path;
    }
    return null;
  }

  static Future<String?> resolve(String? stored) async {
    final appDir = await getApplicationDocumentsDirectory();
    return resolveSync(stored, appDir.path);
  }

  /// Migrates a legacy absolute [stored] value to a bare documents file name.
  static String? normalizeStoredValue(String? stored) {
    if (stored == null || stored.isEmpty) return null;
    if (!stored.contains('/')) return stored;
    return p.basename(stored);
  }
}
