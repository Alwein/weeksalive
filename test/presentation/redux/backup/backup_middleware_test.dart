import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/redux/app_reducer.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/redux/backup/backup_middleware.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/day/day_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

import '../../../fixtures/user_fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockBackupRepository repository;

  final cloudManifest = BackupManifest(
    formatVersion: 1,
    createdAt: DateTime(2026, 9, 1),
    dayCount: 247,
    imageCount: 80,
  );
  final uploadedManifest = BackupManifest(
    formatVersion: 1,
    createdAt: DateTime(2026, 9, 28),
    dayCount: 1,
    imageCount: 0,
  );

  setUp(() {
    repository = MockBackupRepository();
    when(() => repository.isICloudAvailable()).thenAnswer((_) async => true);
    when(
      () => repository.backupToICloud(),
    ).thenAnswer((_) async => uploadedManifest);
  });

  AppState stateWith({bool withUser = true, int days = 1}) {
    final entries = {
      for (var i = 0; i < days; i++)
        normalizeDay(DateTime(2026, 9, 1 + i)): DayEntry(
          date: DateTime(2026, 9, 1 + i),
        ),
    };
    return AppState.initial().copyWith(
      userState: withUser
          ? UserState.success(userFixture())
          : const UserState.success(null),
      dayState: DayState(entries: entries),
    );
  }

  Store<AppState> storeWith(AppState state) {
    return Store<AppState>(
      appReducer,
      initialState: state,
      middleware: [BackupMiddleware(backupRepository: repository).call],
    );
  }

  /// Lets the middleware's async work settle.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 10));

  test(
    'a device that already backed up refreshes its iCloud copy at launch',
    () async {
      when(
        () => repository.lastICloudBackupAt,
      ).thenReturn(DateTime(2026, 9, 27));
      final store = storeWith(stateWith());

      store.dispatch(BootstrapAction());
      await settle();

      verify(() => repository.backupToICloud()).called(1);
      verifyNever(() => repository.findICloudBackup());
      expect(
        store.state.backupState.lastICloudBackupAt,
        uploadedManifest.createdAt,
      );
    },
  );

  test(
    'after a reinstall, an existing iCloud backup is offered and never overwritten',
    () async {
      when(
        () => repository.findICloudBackup(),
      ).thenAnswer((_) async => cloudManifest);
      final store = storeWith(stateWith());

      store.dispatch(BootstrapAction());
      await settle();
      store.dispatch(const RequestICloudBackupAction());
      await settle();

      verifyNever(() => repository.backupToICloud());
      expect(store.state.backupState.restorableICloudBackup, cloudManifest);
      expect(store.state.backupState.restorePromptPending, isTrue);
    },
  );

  test('a device with no recorded day never makes its first backup', () async {
    final store = storeWith(stateWith(days: 0));

    store.dispatch(BootstrapAction());
    await settle();

    verifyNever(() => repository.backupToICloud());
  });

  test(
    'the first backup looks for an iCloud backup again right before uploading',
    () async {
      // The listing is empty at launch, as right after a reinstall…
      var lookups = 0;
      when(
        () => repository.findICloudBackup(),
      ).thenAnswer((_) async => ++lookups == 1 ? null : cloudManifest);
      final store = storeWith(stateWith());

      store.dispatch(BootstrapAction());
      await settle();

      // …and the backup shows up by the time of the first upload.
      verifyNever(() => repository.backupToICloud());
      expect(store.state.backupState.restorableICloudBackup, cloudManifest);
    },
  );

  test('automatic backups wait until the user is onboarded', () async {
    final store = storeWith(stateWith(withUser: false));

    store.dispatch(BootstrapAction());
    await settle();

    verifyNever(() => repository.backupToICloud());
  });

  test('an automatic backup is skipped when nothing changed', () async {
    when(() => repository.lastICloudBackupAt).thenReturn(DateTime(2026, 9, 27));
    final store = storeWith(stateWith());

    store.dispatch(BootstrapAction());
    await settle();
    store.dispatch(const RequestICloudBackupAction());
    await settle();

    verify(() => repository.backupToICloud()).called(1);
  });

  test(
    'replacing an unsynced iCloud backup requires an explicit request',
    () async {
      when(
        () => repository.findICloudBackup(),
      ).thenAnswer((_) async => cloudManifest);
      final store = storeWith(stateWith());
      store.dispatch(BootstrapAction());
      await settle();

      final backUpNow = Completer<void>();
      store.dispatch(
        RequestICloudBackupAction(userInitiated: true, completer: backUpNow),
      );
      await expectLater(backUpNow.future, throwsStateError);
      verifyNever(() => repository.backupToICloud());

      final replace = Completer<void>();
      store.dispatch(
        RequestICloudBackupAction(
          userInitiated: true,
          replaceExisting: true,
          completer: replace,
        ),
      );
      await replace.future;

      verify(() => repository.backupToICloud()).called(1);
      expect(store.state.backupState.restorableICloudBackup, isNull);
    },
  );

  test('a restore reloads the app state and ends the restore offer', () async {
    when(
      () => repository.findICloudBackup(),
    ).thenAnswer((_) async => cloudManifest);
    when(
      () => repository.restoreFromICloud(),
    ).thenAnswer((_) async => cloudManifest);
    final store = storeWith(stateWith());
    final dispatched = <Object>[];
    final spy = Store<AppState>(
      appReducer,
      initialState: store.state,
      middleware: [
        (store, action, next) {
          dispatched.add(action as Object);
          next(action);
        },
        BackupMiddleware(backupRepository: repository).call,
      ],
    );
    spy.dispatch(BootstrapAction());
    await settle();

    final completer = Completer<BackupManifest>();
    spy.dispatch(RestoreFromICloudAction(completer));

    expect(await completer.future, cloudManifest);
    expect(dispatched.whereType<DataRestoredAction>(), hasLength(1));
    expect(spy.state.backupState.restorableICloudBackup, isNull);
  });
}
