/// Summary of a backup, stored next to its data as `manifest.json` so a backup
/// can be described ("247 days, saved on…") without reading all of it.
class BackupManifest {
  /// Bumped when the backup layout changes in a way older app versions cannot
  /// read. A backup newer than [BackupManifest.currentFormatVersion] is refused.
  static const int currentFormatVersion = 1;

  final int formatVersion;
  final DateTime createdAt;
  final int dayCount;
  final int imageCount;

  const BackupManifest({
    required this.formatVersion,
    required this.createdAt,
    required this.dayCount,
    required this.imageCount,
  });

  bool get isSupported => formatVersion <= currentFormatVersion;

  Map<String, dynamic> toJson() => {
    'formatVersion': formatVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'dayCount': dayCount,
    'imageCount': imageCount,
  };

  factory BackupManifest.fromJson(Map<String, dynamic> json) {
    return BackupManifest(
      formatVersion: json['formatVersion'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      dayCount: json['dayCount'] as int? ?? 0,
      imageCount: json['imageCount'] as int? ?? 0,
    );
  }
}

class BackupException implements Exception {
  final BackupError error;
  const BackupException(this.error);

  @override
  String toString() => 'BackupException($error)';
}

enum BackupError {
  /// The file or folder does not contain a WeeksAlive backup.
  invalidBackup,

  /// The backup was made by a newer app version.
  unsupportedVersion,

  /// iCloud is signed out, disabled for the app, or full.
  iCloudUnavailable,

  /// No backup exists in iCloud.
  noICloudBackup,
}
