import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/backup/backup_flows.dart';
import 'package:weeksalive/presentation/backup/data_backup_view_model.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class DataBackupPage extends StatelessWidget {
  const DataBackupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => const DataBackupPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.dataBackupPageTitle),
      body: StoreConnector<AppState, DataBackupViewModel>(
        converter: (store) =>
            DataBackupViewModel.create(store, isIOS: Platform.isIOS),
        builder: (context, viewModel) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Margins.spacingBase),
              Texts.xlBold(viewModel.dayCount),
              if (viewModel.iCloudStatus != ICloudBackupStatus.unsupported) ...[
                const SizedBox(height: Margins.spacingM),
                Texts.primaryRegularMedium(
                  Strings.dataBackupICloudSection,
                  color: AppColors.contentSoft(context),
                ),
                const SizedBox(height: Margins.spacingBase),
                _ICloudCard(viewModel: viewModel),
              ],
              const SizedBox(height: Margins.spacingM),
              Texts.primaryRegularMedium(
                Strings.dataBackupManualSection,
                color: AppColors.contentSoft(context),
              ),
              const SizedBox(height: Margins.spacingBase),
              _ManualCard(viewModel: viewModel),
              const SizedBox(height: Margins.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}

class _ICloudCard extends StatelessWidget {
  const _ICloudCard({required this.viewModel});

  final DataBackupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: switch (viewModel.iCloudStatus) {
        ICloudBackupStatus.unavailable => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: MingCuteIcons.mgc_cloud_line,
              title: Strings.dataBackupICloudUnavailableTitle,
              iconColor: AppColors.redWarning(context),
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(
              context,
              Strings.dataBackupICloudUnavailableDescription,
            ),
            const SizedBox(height: Margins.spacingBase),
            SecondaryButton(
              text: Strings.dataBackupOpenSettings,
              icon: MingCuteIcons.mgc_settings_3_line,
              onPressed: () => AppSettings.openAppSettings(),
            ),
          ],
        ),
        ICloudBackupStatus.restoreAvailable => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: MingCuteIcons.mgc_cloud_line,
              title: Strings.dataBackupICloudFoundTitle,
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryBold(
              BackupFlows.describe(context, viewModel.restorableBackup!),
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(context, Strings.dataBackupICloudFoundHint),
            const SizedBox(height: Margins.spacingBase),
            PrimaryButton(
              text: Strings.dataBackupRestore,
              icon: MingCuteIcons.mgc_download_2_line,
              onPressed: () => BackupFlows.restoreFromICloud(context),
            ),
            const SizedBox(height: Margins.spacingS),
            SecondaryButton(
              text: Strings.dataBackupReplace,
              onPressed: () => BackupFlows.replaceICloudBackup(context),
            ),
          ],
        ),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: MingCuteIcons.mgc_cloud_line,
              title: Strings.dataBackupICloudTitle,
              iconColor: viewModel.iCloudStatus == ICloudBackupStatus.failed
                  ? AppColors.redWarning(context)
                  : AppColors.greenSuccess(context),
            ),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(
              context,
              Strings.dataBackupICloudDescription,
            ),
            const SizedBox(height: Margins.spacingBase),
            const SmallDivider(width: double.infinity),
            const SizedBox(height: Margins.spacingBase),
            Texts.primaryBold(
              viewModel.iCloudStatus == ICloudBackupStatus.inProgress
                  ? Strings.dataBackupICloudInProgress
                  : viewModel.iCloudLastBackup,
            ),
            if (viewModel.iCloudStatus == ICloudBackupStatus.failed) ...[
              const SizedBox(height: Margins.spacingS),
              Texts.primaryRegularMedium(
                Strings.dataBackupICloudFailed,
                color: AppColors.redWarning(context),
              ),
            ],
            const SizedBox(height: Margins.spacingBase),
            SecondaryButton(
              text: Strings.dataBackupICloudBackupNow,
              icon: MingCuteIcons.mgc_upload_2_line,
              onPressed: viewModel.iCloudStatus == ICloudBackupStatus.inProgress
                  ? null
                  : () => BackupFlows.backUpNow(context),
            ),
          ],
        ),
      },
    );
  }
}

class _ManualCard extends StatelessWidget {
  const _ManualCard({required this.viewModel});

  final DataBackupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            icon: MingCuteIcons.mgc_file_export_line,
            title: Strings.dataBackupExport,
          ),
          const SizedBox(height: Margins.spacingS),
          Texts.primaryMediumSoft(context, Strings.dataBackupExportDescription),
          if (viewModel.lastExport != null) ...[
            const SizedBox(height: Margins.spacingS),
            Texts.primaryRegularMedium(
              viewModel.lastExport!,
              color: AppColors.contentSoft(context),
            ),
          ],
          const SizedBox(height: Margins.spacingBase),
          // Builder: the share sheet anchors to this button on iPad.
          Builder(
            builder: (buttonContext) => PrimaryButton(
              text: Strings.dataBackupExport,
              icon: MingCuteIcons.mgc_share_2_line,
              onPressed: () => BackupFlows.exportToFile(buttonContext),
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          SecondaryButton(
            text: Strings.dataBackupImport,
            icon: MingCuteIcons.mgc_file_import_line,
            onPressed: () => BackupFlows.importFromFile(context),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.icon, required this.title, this.iconColor});

  final IconData icon;
  final String title;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: Dimens.iconSizeS,
          color: iconColor ?? AppColors.content(context),
        ),
        const SizedBox(width: Margins.spacingS),
        Expanded(child: Texts.primaryBold(title)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(
          color: AppColors.strokeColor(context),
          width: Dimens.strokeWidthS,
        ),
      ),
      child: child,
    );
  }
}
