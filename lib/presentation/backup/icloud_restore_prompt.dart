import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/backup/backup_manifest.dart';
import 'package:weeksalive/presentation/backup/backup_flows.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/backup/backup_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Offers to restore an iCloud backup this device never synced with (after a
/// reinstall or on a new phone), once per launch, over onboarding or home.
class ICloudRestorePromptListener extends StatefulWidget {
  const ICloudRestorePromptListener({super.key, required this.child});

  final Widget child;

  @override
  State<ICloudRestorePromptListener> createState() =>
      _ICloudRestorePromptListenerState();
}

class _ICloudRestorePromptListenerState
    extends State<ICloudRestorePromptListener> {
  bool _shown = false;

  void _tryShow(BuildContext context, {required BackupManifest? pending}) {
    if (_shown || pending == null) return;

    _shown = true;
    final store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(const ICloudRestorePromptShownAction());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final restore = await ICloudRestorePromptSheet.show(
        this.context,
        pending,
      );
      if (restore == true && mounted) {
        await BackupFlows.restoreFromICloud(this.context, confirm: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BackupManifest?>(
      converter: (store) {
        final backup = store.state.backupState;
        return backup.restorePromptPending
            ? backup.restorableICloudBackup
            : null;
      },
      distinct: true,
      onInitialBuild: (pending) => _tryShow(context, pending: pending),
      onWillChange: (previous, next) => _tryShow(context, pending: next),
      builder: (context, _) => widget.child,
    );
  }
}

/// Resolves to `true` when the user chooses to restore.
class ICloudRestorePromptSheet extends StatelessWidget {
  const ICloudRestorePromptSheet({super.key, required this.manifest});

  final BackupManifest manifest;

  static Future<bool?> show(BuildContext context, BackupManifest manifest) {
    return showCustomBottomSheet<bool>(
      context,
      (context) => ICloudRestorePromptSheet(manifest: manifest),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingBase),
          Icon(
            MingCuteIcons.mgc_cloud_line,
            size: 48,
            color: AppColors.content(context),
          ),
          const SizedBox(height: Margins.spacingM),
          Texts.xlBold(Strings.backupRestorePromptTitle),
          const SizedBox(height: Margins.spacingS),
          Texts.primaryMediumSoft(
            context,
            Strings.backupRestorePromptBody(
              days: Strings.backupDays(manifest.dayCount),
              date: DateFormat.yMMMd(locale).format(manifest.createdAt),
            ),
          ),
          const SizedBox(height: Margins.spacingM),
          PrimaryButton(
            text: Strings.dataBackupRestore,
            icon: MingCuteIcons.mgc_download_2_line,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: Margins.spacingS),
          SecondaryButton(
            text: Strings.backupRestorePromptLater,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}
