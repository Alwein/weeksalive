import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// The user-facing backup flows (confirm, progress, result), shared by the
/// data page, the iCloud restore prompt and onboarding.
abstract final class BackupFlows {
  /// "247 days · saved on Sep 12, 2026".
  static String describe(BuildContext context, BackupManifest manifest) {
    final locale = Localizations.localeOf(context).toString();
    return Strings.dataBackupSummary(
      days: Strings.backupDays(manifest.dayCount),
      date: DateFormat.yMMMd(locale).format(manifest.createdAt),
    );
  }

  static Future<void> restoreFromICloud(
    BuildContext context, {
    bool confirm = true,
  }) async {
    if (confirm &&
        !await _confirm(
          context,
          title: Strings.dataBackupRestoreConfirmTitle,
          body: Strings.dataBackupRestoreConfirmBody,
          confirmLabel: Strings.dataBackupRestore,
        )) {
      return;
    }
    if (!context.mounted) return;

    final completer = Completer<BackupManifest>();
    StoreProvider.of<AppState>(
      context,
      listen: false,
    ).dispatch(RestoreFromICloudAction(completer));
    await _runRestore(context, completer.future);
  }

  static Future<void> importFromFile(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    final path = result?.files.singleOrNull?.path;
    if (path == null || !context.mounted) return;

    if (!await _confirm(
      context,
      title: Strings.dataBackupRestoreConfirmTitle,
      body: Strings.dataBackupRestoreConfirmBody,
      confirmLabel: Strings.dataBackupRestore,
    )) {
      return;
    }
    if (!context.mounted) return;

    final completer = Completer<BackupManifest>();
    StoreProvider.of<AppState>(
      context,
      listen: false,
    ).dispatch(ImportBackupArchiveAction(File(path), completer));
    await _runRestore(context, completer.future);
  }

  static Future<void> exportToFile(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final completer = Completer<File>();
    store.dispatch(ExportBackupArchiveAction(completer));

    final File archive;
    try {
      archive = await _withProgress(context, null, completer.future);
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupErrorGeneric);
      }
      return;
    }

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(archive.path, mimeType: 'application/zip')],
        sharePositionOrigin: origin,
      ),
    );
    if (result.status == ShareResultStatus.success) {
      store.dispatch(const BackupArchiveExportedAction());
    }
  }

  static Future<void> backUpNow(BuildContext context) async {
    final completer = Completer<void>();
    StoreProvider.of<AppState>(
      context,
      listen: false,
    ).dispatch(
      RequestICloudBackupAction(userInitiated: true, completer: completer),
    );
    try {
      await completer.future;
      SensorialFeedback.selectionChanged();
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupICloudBackupDone);
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupErrorGeneric);
      }
    }
  }

  static Future<void> replaceICloudBackup(BuildContext context) async {
    if (!await _confirm(
      context,
      title: Strings.dataBackupReplaceConfirmTitle,
      body: Strings.dataBackupReplaceConfirmBody,
      confirmLabel: Strings.dataBackupReplaceConfirm,
    )) {
      return;
    }
    if (!context.mounted) return;

    final completer = Completer<void>();
    StoreProvider.of<AppState>(context, listen: false).dispatch(
      RequestICloudBackupAction(
        userInitiated: true,
        replaceExisting: true,
        completer: completer,
      ),
    );
    try {
      await completer.future;
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupICloudBackupDone);
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupErrorGeneric);
      }
    }
  }

  static Future<void> _runRestore(
    BuildContext context,
    Future<BackupManifest> restore,
  ) async {
    try {
      final manifest = await _withProgress(
        context,
        Strings.dataBackupRestoreInProgress,
        restore,
      );
      SensorialFeedback.selectionChanged();
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupRestored(manifest.dayCount));
      }
    } on BackupException catch (exception) {
      if (!context.mounted) return;
      _showMessage(context, switch (exception.error) {
        BackupError.invalidBackup => Strings.dataBackupErrorInvalid,
        BackupError.unsupportedVersion => Strings.dataBackupErrorVersion,
        _ => Strings.dataBackupErrorGeneric,
      });
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, Strings.dataBackupErrorGeneric);
      }
    }
  }

  /// Shows a blocking progress dialog until [future] completes.
  static Future<T> _withProgress<T>(
    BuildContext context,
    String? message,
    Future<T> future,
  ) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) =>
            PopScope(canPop: false, child: _ProgressDialog(message: message)),
      ),
    );
    try {
      return await future;
    } finally {
      navigator.pop();
    }
  }

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _ConfirmDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        dialogContext: dialogContext,
      ),
    );
    return confirmed == true;
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.dialogContext,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      title: Texts.primaryMediumBold(title),
      content: Texts.primaryMediumSoft(context, body),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              text: confirmLabel,
            ),
            const SizedBox(height: Margins.spacingS),
            SecondaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              text: Strings.dataBackupCancel,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.content(context)),
            if (message != null) ...[
              const SizedBox(height: Margins.spacingBase),
              Texts.primaryMediumSoft(
                context,
                message!,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
