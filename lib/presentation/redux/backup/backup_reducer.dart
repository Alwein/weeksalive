import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/redux/backup/backup_state.dart';

BackupState backupReducer(BackupState state, dynamic action) {
  if (action is BackupStatusLoadedAction) {
    return state.copyWith(
      iCloudAvailable: action.iCloudAvailable,
      lastICloudBackupAt: () => action.lastICloudBackupAt,
      lastExportAt: () => action.lastExportAt,
    );
  }

  if (action is ICloudBackupStartedAction) {
    return state.copyWith(iCloudBackupInProgress: true);
  }

  if (action is ICloudBackupSucceededAction) {
    return state.copyWith(
      iCloudBackupInProgress: false,
      iCloudBackupFailed: false,
      lastICloudBackupAt: () => action.backedUpAt,
      restorableICloudBackup: () => null,
      restorePromptPending: false,
    );
  }

  if (action is ICloudBackupFailedAction) {
    return state.copyWith(
      iCloudBackupInProgress: false,
      iCloudBackupFailed: true,
    );
  }

  if (action is ICloudRestoreAvailableAction) {
    return state.copyWith(
      restorableICloudBackup: () => action.manifest,
      restorePromptPending: true,
    );
  }

  if (action is ICloudRestorePromptShownAction) {
    return state.copyWith(restorePromptPending: false);
  }

  if (action is DataRestoredAction) {
    return state.copyWith(
      restorableICloudBackup: () => null,
      restorePromptPending: false,
    );
  }

  if (action is BackupArchiveExportedAction) {
    return state.copyWith(lastExportAt: () => DateTime.now());
  }

  return state;
}
