import 'package:jiffy/jiffy.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

enum ICloudBackupStatus {
  unsupported,
  unavailable,
  restoreAvailable,
  idle,
  inProgress,
  failed,
}

class DataBackupViewModel {
  const DataBackupViewModel({
    required this.dayCount,
    required this.iCloudStatus,
    required this.iCloudLastBackup,
    required this.restorableBackup,
    required this.lastExport,
  });

  final String dayCount;
  final ICloudBackupStatus iCloudStatus;

  /// "Last backup: 3 minutes ago", or the "no backup yet" label.
  final String iCloudLastBackup;
  final BackupManifest? restorableBackup;
  final String? lastExport;

  factory DataBackupViewModel.create(
    Store<AppState> store, {
    required bool isIOS,
  }) {
    final backup = store.state.backupState;

    final ICloudBackupStatus status;
    if (!isIOS) {
      status = ICloudBackupStatus.unsupported;
    } else if (!backup.iCloudAvailable) {
      status = ICloudBackupStatus.unavailable;
    } else if (backup.restorableICloudBackup != null) {
      status = ICloudBackupStatus.restoreAvailable;
    } else if (backup.iCloudBackupInProgress) {
      status = ICloudBackupStatus.inProgress;
    } else if (backup.iCloudBackupFailed) {
      status = ICloudBackupStatus.failed;
    } else {
      status = ICloudBackupStatus.idle;
    }

    final lastICloud = backup.lastICloudBackupAt;
    final lastExport = backup.lastExportAt;

    return DataBackupViewModel(
      dayCount: Strings.backupDays(store.state.dayState.entries.length),
      iCloudStatus: status,
      iCloudLastBackup: lastICloud != null
          ? Strings.dataBackupICloudLast(relativeTime(lastICloud))
          : Strings.dataBackupICloudNever,
      restorableBackup: backup.restorableICloudBackup,
      lastExport: lastExport != null
          ? Strings.dataBackupLastExport(relativeTime(lastExport))
          : null,
    );
  }
}

/// "3 minutes ago", in the app language.
String relativeTime(DateTime date) => Jiffy.parseFromDateTime(date).fromNow();
