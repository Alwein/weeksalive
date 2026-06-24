import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/grid_motif/grid_cell_variant.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_renderer.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_rules.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/grid_motif/grid_motif_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class GridMotifPickerViewModel {
  const GridMotifPickerViewModel({
    required this.selectedMotif,
    required this.unlockedMotifs,
  });

  final GridMotifId selectedMotif;
  final Set<GridMotifId> unlockedMotifs;
}

class GridMotifPicker extends StatelessWidget {
  const GridMotifPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GridMotifPickerViewModel>(
      converter: (store) => GridMotifPickerViewModel(
        selectedMotif: store.state.gridMotifState.selectedMotif,
        unlockedMotifs: store.state.gridMotifState.unlockedMotifs,
      ),
      builder: (context, viewModel) => _GridMotifGrid(viewModel: viewModel),
    );
  }
}

class _GridMotifGrid extends StatelessWidget {
  const _GridMotifGrid({required this.viewModel});

  final GridMotifPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      itemCount: GridMotifId.all.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: Margins.spacingBase,
        crossAxisSpacing: Margins.spacingBase,
      ),
      itemBuilder: (context, index) {
        final motifId = GridMotifId.all[index];
        return _GridMotifCard(
          motifId: motifId,
          selected: motifId == viewModel.selectedMotif,
          locked: !viewModel.unlockedMotifs.contains(motifId),
          onTap: () {
            if (!viewModel.unlockedMotifs.contains(motifId)) return;
            SensorialFeedback.selectionChanged();
            StoreProvider.of<AppState>(context).dispatch(SetGridMotifAction(motifId));
          },
        );
      },
    );
  }
}

class _GridMotifCard extends StatelessWidget {
  const _GridMotifCard({
    required this.motifId,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final GridMotifId motifId;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusL - Dimens.strokeWidthBase),
          child: _GridMotifCardContent(
            motifId: motifId,
            selected: selected,
            locked: locked,
          ),
        ),
      ),
    );
  }
}

class _GridMotifCardContent extends StatelessWidget {
  const _GridMotifCardContent({
    required this.motifId,
    required this.selected,
    required this.locked,
  });

  static const _previewSize = 96.0;

  final GridMotifId motifId;
  final bool selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);
    final hintColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);
    final cellColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);
    final emptyColor = selected ? AppColors.contentSoftOnSoft(context) : AppColors.strokeColor(context);

    return Padding(
      padding: const EdgeInsets.all(Margins.spacingBase),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: _previewSize,
              height: _previewSize,
              child: CustomPaint(
                painter: _GridMotifPreviewPainter(
                  motifId: motifId,
                  cellColor: cellColor,
                  emptyColor: emptyColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
          Center(
            child: locked
                ? _LockedLabel(motifId: motifId, textColor: textColor, hintColor: hintColor)
                : Texts.primaryMediumBold(
                    motifId.label,
                    color: textColor,
                    textAlign: TextAlign.center,
                  ),
          ),
        ],
      ),
    );
  }
}

class _LockedLabel extends StatelessWidget {
  const _LockedLabel({
    required this.motifId,
    required this.textColor,
    required this.hintColor,
  });

  final GridMotifId motifId;
  final Color textColor;
  final Color hintColor;

  String? get _unlockHint {
    final rule = RewardRules.ruleForGridMotif(motifId);
    if (rule == null) return null;
    return switch (rule.condition) {
      StreakMilestoneCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
      TotalDaysLoggedCondition(:final minDays) => Strings.themeLockedStreakHint(minDays),
    };
  }

  @override
  Widget build(BuildContext context) {
    final hint = _unlockHint;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(MingCuteIcons.mgc_lock_line, color: textColor, size: Dimens.iconSizeS),
            const SizedBox(width: Margins.spacingS),
            Flexible(
              child: Texts.primaryMediumBold(
                motifId.label,
                color: textColor,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: Margins.spacingS),
          Texts.primaryRegular(hint, color: hintColor, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

class _GridMotifPreviewPainter extends CustomPainter {
  const _GridMotifPreviewPainter({
    required this.motifId,
    required this.cellColor,
    required this.emptyColor,
  });

  static const _columns = 4;
  static const _rows = 4;
  static const _spacing = 3.0;

  final GridMotifId motifId;
  final Color cellColor;
  final Color emptyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = (size.width - _spacing * (_columns - 1)) / _columns;
    final livedCount = 10;

    for (var i = 0; i < _columns * _rows; i++) {
      final rect = GridMotifRenderer.cellRect(
        padding: EdgeInsets.zero,
        columns: _columns,
        dotSpacing: _spacing,
        dotSize: dotSize,
        index: i,
      );
      final isLived = i < livedCount;
      GridMotifRenderer.draw(
        canvas: canvas,
        motifId: motifId,
        variant: gridCellVariantForLifeWeek(isLived: isLived),
        cellIndex: i,
        rect: rect,
        color: isLived ? cellColor : emptyColor,
        scale: 1.0,
        isStroke: false,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridMotifPreviewPainter old) =>
      old.motifId != motifId || old.cellColor != cellColor || old.emptyColor != emptyColor;
}
