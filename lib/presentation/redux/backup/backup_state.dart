import 'package:weeksalive/domain/backup/backup_manifest.dart';

class BackupState {
  const BackupState({
    this.iCloudAvailable = false,
    this.lastICloudBackupAt,
    this.lastExportAt,
    this.iCloudBackupInProgress = false,
    this.iCloudBackupFailed = false,
    this.restorableICloudBackup,
    this.restorePromptPending = false,
  });

  final bool iCloudAvailable;
  final DateTime? lastICloudBackupAt;
  final DateTime? lastExportAt;
  final bool iCloudBackupInProgress;

  /// True when the last automatic or manual iCloud backup failed.
  final bool iCloudBackupFailed;

  /// An iCloud backup this device has never synced with (reinstall, new
  /// phone). While set, automatic backups are suspended so they cannot
  /// overwrite it; the user restores it or explicitly replaces it.
  final BackupManifest? restorableICloudBackup;

  /// True while the restore offer is waiting to be shown by
  /// `ICloudRestorePromptListener`.
  final bool restorePromptPending;

  BackupState copyWith({
    bool? iCloudAvailable,
    DateTime? Function()? lastICloudBackupAt,
    DateTime? Function()? lastExportAt,
    bool? iCloudBackupInProgress,
    bool? iCloudBackupFailed,
    BackupManifest? Function()? restorableICloudBackup,
    bool? restorePromptPending,
  }) {
    return BackupState(
      iCloudAvailable: iCloudAvailable ?? this.iCloudAvailable,
      lastICloudBackupAt: lastICloudBackupAt != null
          ? lastICloudBackupAt()
          : this.lastICloudBackupAt,
      lastExportAt: lastExportAt != null ? lastExportAt() : this.lastExportAt,
      iCloudBackupInProgress:
          iCloudBackupInProgress ?? this.iCloudBackupInProgress,
      iCloudBackupFailed: iCloudBackupFailed ?? this.iCloudBackupFailed,
      restorableICloudBackup: restorableICloudBackup != null
          ? restorableICloudBackup()
          : this.restorableICloudBackup,
      restorePromptPending: restorePromptPending ?? this.restorePromptPending,
    );
  }
}
