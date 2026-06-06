import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:weeksalive/core/utils/compress_image.dart';

abstract interface class ImageStorage {
  /// Saves an image from [absolutePath] into the app documents directory.
  /// Returns the stable [fileName] (e.g. "1749200000000.jpeg").
  Future<String> save(String absolutePath);

  /// Resolves a [fileName] to a stable absolute path in the app documents directory.
  Future<String> resolve(String fileName);
}

class LocalImageStorage implements ImageStorage {
  @override
  Future<String> save(String absolutePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final (fileName, compressedPath) = await ImageCompressor.compressImage(absolutePath);

    if (fileName == null || compressedPath == null) {
      throw Exception('Failed to compress image at $absolutePath');
    }

    final savedPath = p.join(appDir.path, fileName);
    await File(compressedPath).copy(savedPath);
    return fileName;
  }

  @override
  Future<String> resolve(String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, fileName);
  }
}
