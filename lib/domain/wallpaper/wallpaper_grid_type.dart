/// Which of the two grids is rendered onto the wallpaper.
enum WallpaperGridType {
  /// Life-in-weeks grid: one cell per week of life. Updates weekly.
  life,

  /// Current civil year grid: one cell per day of the year. Updates daily.
  year;

  String get storageKey => name;

  static WallpaperGridType fromStorageKey(String? value) {
    for (final type in values) {
      if (type.storageKey == value) return type;
    }
    return WallpaperGridType.life;
  }
}
