import 'dart:async';
import 'dart:io';

import 'package:weeksalive/domain/backup/backup_manifest.dart';

class BackupStatusLoadedAction {
  final bool iCloudAvailable;
  final DateTime? lastICloudBackupAt;
  final DateTime? lastExportAt;

  const BackupStatusLoadedAction({
    required this.iCloudAvailable,
    required this.lastICloudBackupAt,
    required this.lastExportAt,
  });
}

/// Backs the data up to iCloud.
///
/// Automatic requests (app backgrounded, day saved) are skipped when nothing
/// changed since the last backup or while an unsynced iCloud backup exists.
/// A [userInitiated] request always runs, and with [replaceExisting] it also
/// overwrites an unsynced iCloud backup.
class RequestICloudBackupAction {
  final bool userInitiated;
  final bool replaceExisting;
  final Completer<void>? completer;

  const RequestICloudBackupAction({
    this.userInitiated = false,
    this.replaceExisting = false,
    this.completer,
  });
}

class ICloudBackupStartedAction {
  const ICloudBackupStartedAction();
}

class ICloudBackupSucceededAction {
  final DateTime backedUpAt;
  const ICloudBackupSucceededAction(this.backedUpAt);
}

class ICloudBackupFailedAction {
  const ICloudBackupFailedAction();
}

/// An iCloud backup this device never synced with was found.
class ICloudRestoreAvailableAction {
  final BackupManifest manifest;
  const ICloudRestoreAvailableAction(this.manifest);
}

/// The restore offer was shown; it stays reachable from the data page.
class ICloudRestorePromptShownAction {
  const ICloudRestorePromptShownAction();
}

class RestoreFromICloudAction {
  final Completer<BackupManifest> completer;
  const RestoreFromICloudAction(this.completer);
}

class ExportBackupArchiveAction {
  final Completer<File> completer;
  const ExportBackupArchiveAction(this.completer);
}

/// The exported archive was handed to the share sheet and saved somewhere.
class BackupArchiveExportedAction {
  const BackupArchiveExportedAction();
}

class ImportBackupArchiveAction {
  final File archive;
  final Completer<BackupManifest> completer;
  const ImportBackupArchiveAction(this.archive, this.completer);
}

/// Persisted data was replaced by a restore; slices backed by it reload.
class DataRestoredAction {
  final BackupManifest manifest;
  const DataRestoredAction(this.manifest);
}
