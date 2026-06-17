import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/data/wallpaper/wallpaper_installer.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Full setup guide for iOS Shortcuts automation (shown from the editor).
class WallpaperSetupPage extends StatefulWidget {
  const WallpaperSetupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const WallpaperSetupPage(), fullscreenDialog: true);
  }

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  @override
  State<WallpaperSetupPage> createState() => _WallpaperSetupPageState();
}

class _WallpaperSetupPageState extends State<WallpaperSetupPage> {
  static const _illustratedStepIndices = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};

  late final Map<int, ExpansibleController> _expansionControllers = {
    for (final index in _illustratedStepIndices) index: ExpansibleController(),
  };

  bool get _areAllExpanded => _expansionControllers.values.every((controller) => controller.isExpanded);

  void _onExpansionChanged(bool _) => setState(() {});

  void _toggleAllExpansionTiles() {
    if (_areAllExpanded) {
      for (final controller in _expansionControllers.values) {
        controller.collapse();
      }
    } else {
      for (final controller in _expansionControllers.values) {
        controller.expand();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _expansionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _timelineRow(_TimelineItem item) {
    return _TimelineRow(
      item: item,
      expansionController: _expansionControllers[item.index],
      onExpansionChanged: _onExpansionChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.wallpaperSetupTitle),
      floatingActionButton: FloatingActionButton(
        tooltip: _areAllExpanded ? Strings.wallpaperSetupCollapseAll : Strings.wallpaperSetupExpandAll,
        backgroundColor: AppColors.content(context),
        foregroundColor: AppColors.contentMuted(context),
        elevation: 0,
        onPressed: _toggleAllExpansionTiles,
        child: Icon(_areAllExpanded ? Icons.unfold_less : Icons.unfold_more),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Margins.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.asset('assets/images/shortcuts.webp', width: Dimens.iconSizeHuge, height: Dimens.iconSizeHuge),
                const SizedBox(width: Margins.spacingBase),
                Expanded(
                  child: Texts.primaryRegularMedium(
                    Strings.wallpaperSetupSubtitle,
                    color: AppColors.content(context),
                  ),
                ),
              ],
            ),
            const _SectionDivider(),
            _timelineRow(
              _TimelineItem(
                index: 1,
                label: Strings.wallpaperSetupShortcutTitle,
                additionalContent: PrimaryButton(
                  icon: MingCuteIcons.mgc_external_link_line,
                  iconRight: true,
                  text: Strings.wallpaperOpenShortcuts,
                  onPressed: () => WallpaperInstaller().openShortcutsApp(),
                ),
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 2,
                label: Strings.wallpaperSetupGoToShortcutsPage,
                assetIllustration: 'assets/images/step01_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 3,
                label: Strings.wallpaperSetupCreateAutomation,
                assetIllustration: 'assets/images/step02_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 4,
                label: Strings.wallpaperSetupSelectTimeOfDay,
                assetIllustration: 'assets/images/step03_1x.webp',
              ),
            ),
            StoreConnector<AppState, TimeOfDay>(
              converter: (store) => store.state.pushNotificationState.slots.slot2.time,
              builder: (context, notificationTime) {
                return _timelineRow(
                  _TimelineItem(
                    index: 5,
                    label: Strings.wallpaperSetupSelect,
                    description: Strings.wallpaperSetupSelectDescription(
                      TimeUtils.formatTime(context, notificationTime, minutesOffset: 15),
                    ),
                    assetIllustration: 'assets/images/step04_1x.webp',
                  ),
                );
              },
            ),
            _timelineRow(
              _TimelineItem(
                index: 6,
                label: Strings.wallpaperSetupCreateNewShortcut,
                assetIllustration: 'assets/images/step05_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 7,
                label: Strings.wallpaperSetupSearchAndAddGetWallpaper,
                assetIllustration: 'assets/images/step06_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 8,
                label: Strings.wallpaperSetupSearchAndAddSetWallpaperPhoto,
                assetIllustration: 'assets/images/step07_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 9,
                label: Strings.wallpaperSetupClickOnLockScreenAndHomeScreen,
                assetIllustration: 'assets/images/step08_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 10,
                label: Strings.wallpaperSetupUnselectHomeScreen,
                description: Strings.wallpaperSetupUnselectHomeScreenDescription,
                assetIllustration: 'assets/images/step09_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 11,
                label: Strings.wallpaperSetupClickOnExpandArrow,
                assetIllustration: 'assets/images/step10_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 12,
                label: Strings.wallpaperSetupUnselectShowPreviewAndCropToSubject,
                description: Strings.wallpaperSetupUnselectShowPreviewAndCropToSubjectDescription,
                assetIllustration: 'assets/images/step11_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                index: 13,
                label: Strings.wallpaperSetupPressRunButton,
                assetIllustration: 'assets/images/step12_1x.webp',
              ),
            ),
            _timelineRow(
              _TimelineItem(
                isLast: true,
                index: 14,
                label: Strings.wallpaperSetupYouAreAllSet,
                assetIllustration: 'assets/images/step13_1x.webp',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: Margins.spacingM),
        SmallDivider(width: double.infinity),
        SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.index,
    required this.label,
    this.description,
    this.assetIllustration,
    this.additionalContent,
    this.isLast = false,
  });
  final int index;
  final String label;
  final String? description;
  final String? assetIllustration;
  final Widget? additionalContent;
  final bool isLast;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    this.expansionController,
    this.onExpansionChanged,
  });
  final _TimelineItem item;
  final ExpansibleController? expansionController;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    final Widget dotWidget;

    const double dotSize = Dimens.iconSizeM;
    const double lineWidth = Dimens.strokeWidthS;

    dotColor = AppColors.strokeColor(context);
    dotWidget = Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: dotColor,
          width: lineWidth,
        ),
      ),
      child: Center(
        child: item.isLast
            ? Icon(MingCuteIcons.mgc_check_line, size: Dimens.iconSizeS, color: AppColors.contentSoft(context))
            : Texts.primaryMediumBold(
                item.index.toString(),
                color: AppColors.contentSoft(context),
              ),
      ),
    );

    final labelColor = AppColors.content(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimens.iconSizeM,
            child: Column(
              children: [
                dotWidget,
                if (!item.isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: lineWidth,
                        color: AppColors.strokeColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Margins.spacingS),
                Text(
                  item.label,
                  style: TextStyles.primaryMediumBlack.copyWith(
                    color: labelColor,
                    decorationColor: labelColor,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: Margins.spacingBase),
                  Text(
                    item.description!,
                    style: TextStyles.primaryRegular.copyWith(color: AppColors.contentSoft(context)),
                  ),
                ],
                if (item.additionalContent != null) ...[
                  const SizedBox(height: Margins.spacingBase),
                  item.additionalContent!,
                ],
                if (item.assetIllustration != null) ...[
                  const SizedBox(height: Margins.spacingS),
                  ExpansionTile(
                    controller: expansionController,
                    onExpansionChanged: onExpansionChanged,
                    shape: const Border(),
                    tilePadding: EdgeInsets.zero,
                    dense: true,
                    title: Texts.primaryBold(
                      Strings.wallpaperSetupShowPreview,
                      color: AppColors.contentSoft(context),
                    ),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.radiusXl),
                        child: Image.asset(item.assetIllustration!),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: Margins.spacingBase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
