import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_complete_page.dart';
import 'package:weeksalive/presentation/weekly_summary/weekly_summary_details_page.dart';

Future<void> showWeeklySummarySheet(
  BuildContext context, {
  VoidCallback? onDismissed,
}) {
  final controller = SheetController();

  return Navigator.of(context)
      .push(
        ModalSheetRoute<void>(
          swipeDismissible: true,
          builder: (context) => _WeeklySummarySheetRoot(controller: controller),
        ),
      )
      .then((_) => onDismissed?.call());
}

class _WeeklySummarySheetRoot extends StatefulWidget {
  const _WeeklySummarySheetRoot({required this.controller});

  final SheetController controller;

  @override
  State<_WeeklySummarySheetRoot> createState() => _WeeklySummarySheetRootState();
}

class _WeeklySummarySheetRootState extends State<_WeeklySummarySheetRoot> {
  late final Navigator _nestedNavigator;

  @override
  void initState() {
    super.initState();
    _nestedNavigator = Navigator(
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          PagedSheetRoute<void>(
            initialOffset: const SheetOffset(1),
            snapGrid: const MultiSnapGrid(
              snaps: [SheetOffset(1)],
            ),
            builder: (context) => WeeklySummaryCompletePage(
              onClose: _closeSheet,
              onContinue: () {
                Navigator.of(context).push(
                  PagedSheetRoute<void>(
                    builder: (_) => WeeklySummaryDetailsPage(onClose: _closeSheet),
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  void _closeSheet() => Navigator.of(context, rootNavigator: true).pop();

  @override
  Widget build(BuildContext context) {
    return PagedSheet(
      controller: widget.controller,
      decoration: MaterialSheetDecoration(
        size: SheetSize.stretch,
        color: AppColors.bg(context),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimens.radiusL),
          ),
          side: BorderSide(color: AppColors.strokeColor(context)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      navigator: _nestedNavigator,
    );
  }
}

class WeeklySummaryTopBar extends StatelessWidget {
  const WeeklySummaryTopBar({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
        child: Row(
          children: [
            IconButton(
              onPressed: onClose,
              icon: Icon(
                MingCuteIcons.mgc_close_line,
                size: Dimens.iconSizeBase,
                color: AppColors.content(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
