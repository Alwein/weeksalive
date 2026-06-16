enum WallpaperBackgroundMode {
  solid,
  gradient,
  image;

  String get storageKey => name;

  static WallpaperBackgroundMode fromStorageKey(String? value) {
    for (final mode in values) {
      if (mode.storageKey == value) return mode;
    }
    return WallpaperBackgroundMode.solid;
  }
}
