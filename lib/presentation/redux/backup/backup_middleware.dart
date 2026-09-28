import 'dart:async';

import 'package:redux/redux.dart';
import 'package:weeksalive/data/backup/backup_repository.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';

class BackupMiddleware extends MiddlewareClass<AppState> {
  BackupMiddleware({
    required this.backupRepository,
    this.dayChangeDebounce = const Duration(seconds: 10),
  });

  final BackupRepository backupRepository;

  /// Delay between a day being saved and the automatic backup, so a burst of
  /// edits is uploaded once.
  final Duration dayChangeDebounce;

  /// Something worth backing up changed since the last backup. Starts true so
  /// every launch refreshes the iCloud copy once.
  bool _dirty = true;

  /// The launch-time lookup of an unsynced iCloud backup has finished;
  /// automatic backups wait for it so they never race a restore offer.
  bool _remoteChecked = false;

  Future<void>? _inFlight;
  Timer? _debounce;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      await _loadStatus(store);
    }

    if (_changesBackedUpData(action)) {
      _dirty = true;
    }

    if (action is SaveDayAction || action is DeleteDayAction) {
      _debounce?.cancel();
      _debounce = Timer(dayChangeDebounce, () {
        _dispatch(store, const RequestICloudBackupAction());
      });
    }

    if (action is RequestICloudBackupAction) {
      await _backupToICloud(store, action);
    }

    if (action is RestoreFromICloudAction) {
      await _complete(
        store,
        action.completer,
        backupRepository.restoreFromICloud,
      );
    }

    if (action is ImportBackupArchiveAction) {
      await _complete(
        store,
        action.completer,
        () => backupRepository.importArchive(action.archive),
      );
    }

    if (action is ExportBackupArchiveAction) {
      try {
        action.completer.complete(await backupRepository.exportArchive());
      } catch (error, stackTrace) {
        action.completer.completeError(error, stackTrace);
      }
    }

    if (action is BackupArchiveExportedAction) {
      await backupRepository.markExported();
    }
  }

  Future<void> _loadStatus(Store<AppState> store) async {
    final available = await backupRepository.isICloudAvailable();
    _dispatch(
      store,
      BackupStatusLoadedAction(
        iCloudAvailable: available,
        lastICloudBackupAt: backupRepository.lastICloudBackupAt,
        lastExportAt: backupRepository.lastExportAt,
      ),
    );

    if (available && backupRepository.lastICloudBackupAt == null) {
      await _lookForUnsyncedBackup(store);
    }
    _remoteChecked = true;
    _dispatch(store, const RequestICloudBackupAction());
  }

  /// Returns true when an iCloud backup this device never synced with exists.
  Future<bool> _lookForUnsyncedBackup(Store<AppState> store) async {
    final manifest = await backupRepository.findICloudBackup();
    if (manifest == null || manifest.dayCount == 0) return false;
    if (store.state.backupState.restorableICloudBackup == null) {
      _dispatch(store, ICloudRestoreAvailableAction(manifest));
    }
    return true;
  }

  Future<void> _backupToICloud(
    Store<AppState> store,
    RequestICloudBackupAction action,
  ) async {
    // Serialize backups: a request arriving mid-upload runs after it.
    while (_inFlight != null) {
      await _inFlight;
    }

    final completer = Completer<void>();
    _inFlight = completer.future;
    try {
      await _runBackup(store, action);
      action.completer?.complete();
    } catch (error, stackTrace) {
      action.completer?.completeError(error, stackTrace);
    } finally {
      _inFlight = null;
      completer.complete();
    }
  }

  Future<void> _runBackup(
    Store<AppState> store,
    RequestICloudBackupAction action,
  ) async {
    final state = store.state.backupState;
    if (!state.iCloudAvailable) {
      if (action.userInitiated) {
        throw const BackupException(BackupError.iCloudUnavailable);
      }
      return;
    }
    if (state.restorableICloudBackup != null && !action.replaceExisting) {
      if (action.userInitiated) {
        throw StateError(
          'An unsynced iCloud backup must be restored or replaced first',
        );
      }
      return;
    }

    if (!action.userInitiated) {
      if (!_dirty || !_remoteChecked) return;
      if (store.state.userState.userOrNull == null) return;
      if (backupRepository.lastICloudBackupAt == null) {
        // First upload from this device. Right after a reinstall the iCloud
        // listing can lag behind, so never push an empty history, and look
        // for an existing backup once more before writing over it.
        if (store.state.dayState.entries.isEmpty) return;
        if (await _lookForUnsyncedBackup(store)) return;
      }
    }

    _dirty = false;
    _dispatch(store, const ICloudBackupStartedAction());
    try {
      final manifest = await backupRepository.backupToICloud();
      _dispatch(store, ICloudBackupSucceededAction(manifest.createdAt));
    } catch (_) {
      _dirty = true;
      _dispatch(store, const ICloudBackupFailedAction());
      rethrow;
    }
  }

  Future<void> _complete(
    Store<AppState> store,
    Completer<BackupManifest> completer,
    Future<BackupManifest> Function() restore,
  ) async {
    try {
      final manifest = await restore();
      _dispatch(store, DataRestoredAction(manifest));
      completer.complete(manifest);
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    }
  }

  bool _changesBackedUpData(Object? action) {
    return action is SaveDayAction ||
        action is DeleteDayAction ||
        action is SetUserAction ||
        action is UpdateUserAction ||
        action is SetWeeklyIntentSelectionAction ||
        action is AddWeeklyIntentAction ||
        action is RemoveWeeklyIntentAction ||
        action is UpdateNotificationSettingsAction ||
        action is SetAppThemeAction ||
        action is SetGridMotifAction ||
        action is DataRestoredAction;
  }

  void _dispatch(Store<AppState> store, Object action) {
    try {
      store.dispatch(action);
    } catch (_) {
      // Store torn down (e.g. in tests) during the async gap.
    }
  }
}
