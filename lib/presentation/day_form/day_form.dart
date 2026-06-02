import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/edit_weekly_intent_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class DayForm extends StatelessWidget {
  const DayForm({super.key, required this.date});
  final DateTime date;

  static void showBottomSheet(BuildContext context, DateTime date) =>
      showCustomBottomSheet(context, (context) => DayForm(date: date));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayFormViewModel>(
      converter: (store) => DayFormViewModel.create(store, date),
      builder: (context, viewModel) => _Content(viewModel: viewModel, date: date),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.viewModel, required this.date});
  final DayFormViewModel viewModel;
  final DateTime date;

  @override
  State<_Content> createState() => _ContentState();
}

enum _DaySectionId { feeling, meaning, newExperience, intention, leaveATrace }

const double _kBaseCircleSize = 6;
const double _kMaxStepCircleContribution = 6;

double _proportionalContribution(int index, int valueCount) => index / (valueCount - 1) * _kMaxStepCircleContribution;

class _ContentState extends State<_Content> {
  late final DayFormController _controller;
  _DaySectionId _expanded = _DaySectionId.feeling;

  double get _circleSize {
    final feelingContribution = _controller.averageFeeling != null
        ? _proportionalContribution(_controller.averageFeeling!.index, AverageFeeling.values.length)
        : 0.0;
    final meaningContribution = _controller.meaningScore != null
        ? _proportionalContribution(_controller.meaningScore!.index, MeaningScore.values.length)
        : 0.0;
    final newExperienceContribution = _controller.hasNewExperience == true ? _kMaxStepCircleContribution : 0.0;
    final intentionContribution = _controller.livingIntentions.isNotEmpty ? _kMaxStepCircleContribution : 0.0;

    return _kBaseCircleSize +
        feelingContribution +
        meaningContribution +
        newExperienceContribution +
        intentionContribution;
  }

  @override
  void initState() {
    super.initState();
    _controller = DayFormController(initialEntry: widget.viewModel.existingEntry)..addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  void _toggleExpanded(_DaySectionId id) {
    setState(() {
      _expanded = _expanded == id ? _DaySectionId.feeling : id;
    });
  }

  void _advanceFrom(_DaySectionId current) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final next = switch (current) {
      _DaySectionId.feeling => _controller.meaningScore == null ? _DaySectionId.meaning : _DaySectionId.newExperience,
      _DaySectionId.meaning =>
        _controller.hasNewExperience == null ? _DaySectionId.newExperience : _DaySectionId.meaning,
      _DaySectionId.newExperience => _DaySectionId.newExperience,
      _DaySectionId.intention => _DaySectionId.intention,
      _DaySectionId.leaveATrace => _DaySectionId.leaveATrace,
    };
    setState(() => _expanded = next);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          _DayHeader(circleSize: _circleSize, viewModel: widget.viewModel),
          const SizedBox(height: Margins.spacingBase),
          const SmallDivider(width: double.infinity),

          _DaySection(
            index: '01',
            title: Strings.feelingSectionTitle,
            isExpanded: _expanded == _DaySectionId.feeling,
            isAnswered: _controller.averageFeeling != null,
            onTap: () => _toggleExpanded(_DaySectionId.feeling),
            summary: _controller.averageFeeling != null ? _FeelingSummary(value: _controller.averageFeeling!) : null,
            child: _FeelingSelector(
              value: _controller.averageFeeling,
              onChanged: (v) {
                _controller.setAverageFeeling(v);
                _advanceFrom(_DaySectionId.feeling);
              },
            ),
          ),

          _DaySection(
            index: '02',
            title: Strings.meaningSectionTitle,
            isExpanded: _expanded == _DaySectionId.meaning,
            isAnswered: _controller.meaningScore != null,
            onTap: () => _toggleExpanded(_DaySectionId.meaning),
            summary: _controller.meaningScore != null ? _MeaningSummary(value: _controller.meaningScore!) : null,
            child: _MeaningSelector(
              value: _controller.meaningScore,
              onChanged: (v) {
                _controller.setMeaningScore(v);
                _advanceFrom(_DaySectionId.meaning);
              },
            ),
          ),

          _DaySection(
            index: '03',
            title: Strings.newExperienceSectionTitle,
            isExpanded: _expanded == _DaySectionId.newExperience,
            isAnswered: _controller.hasNewExperience != null,
            onTap: () => _toggleExpanded(_DaySectionId.newExperience),
            summary: _controller.hasNewExperience != null
                ? _NewExperienceSummary(value: _controller.hasNewExperience!)
                : null,
            child: _NewExperienceSelector(
              value: _controller.hasNewExperience,
              onChanged: (v) {
                _controller.setHasNewExperience(v);
                _advanceFrom(_DaySectionId.intention);
              },
            ),
          ),

          _DaySection(
            index: '04',
            title: Strings.livingIntentionsSectionTitle,
            isExpanded: _expanded == _DaySectionId.intention,
            isAnswered: _controller.livingIntentions.isNotEmpty,
            onTap: () => _toggleExpanded(_DaySectionId.intention),
            summary: _controller.livingIntentions.isNotEmpty
                ? _LivingIntentionsSummary(selectedIds: _controller.livingIntentions)
                : null,
            child: _LivingIntentionsSelector(
              value: _controller.livingIntentions,
              onToggle: (id) {
                _controller.toggleLivingIntention(id);
              },
              onAllSelected: () => _advanceFrom(_DaySectionId.leaveATrace),
            ),
          ),

          _DaySection(
            index: '05',
            title: Strings.leaveATraceSectionTitle,
            isExpanded: _expanded == _DaySectionId.leaveATrace,
            isAnswered: _controller.leaveATrace.isAnswered,
            onTap: () => _toggleExpanded(_DaySectionId.leaveATrace),
            summary: _controller.leaveATrace.isAnswered ? _LeaveATraceSummary(value: _controller.leaveATrace) : null,
            child: _LeaveATraceInput(
              value: _controller.leaveATrace,
              onChanged: (v) {
                _controller.setLeaveATrace(v);
              },
            ),
          ),
          const SizedBox(height: Margins.spacingBase),
          PrimaryButton(
            text: Strings.done,
            onPressed: _controller.canSave
                ? () {
                    SensorialFeedback.selectionChanged();
                    StoreProvider.of<AppState>(context).dispatch(
                      SaveDayAction(_controller.buildEntry(widget.date)),
                    );
                    Navigator.of(context).pop();
                  }
                : null,
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.circleSize, required this.viewModel});
  final DayFormViewModel viewModel;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Texts.primaryXsCounter(
                context,
                Strings.dayLabel,
                "#${viewModel.dayCount}",
                softColor: AppColors.contentSoftOnSoft(context),
              ),
              const SizedBox(height: Margins.spacingXs),
              Texts.primaryLargeBold(TimeUtils.formatDate(context, DateTime.now())),
            ],
          ),
        ),
        const SizedBox(width: Margins.spacingBase),
        AnimatedContainer(
          duration: AnimationDurations.short,
          curve: Curves.easeInOut,
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: AppColors.content(context),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.index,
    required this.title,
    required this.isExpanded,
    required this.isAnswered,
    required this.onTap,
    required this.child,
    this.summary,
  });

  final String index;
  final String title;
  final bool isExpanded;
  final bool isAnswered;
  final VoidCallback onTap;
  final Widget child;
  final Widget? summary;

  @override
  Widget build(BuildContext context) {
    final bool isInactive = !isExpanded && !isAnswered;
    final Color titleColor = isInactive ? AppColors.contentSoft(context) : AppColors.content(context);
    final Color indexColor = AppColors.contentExtraSoft(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            SensorialFeedback.selectionChanged();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacingBase),
            child: Row(
              children: [
                Text(
                  index,
                  style: TextStyles.primaryMediumBold.copyWith(color: indexColor),
                ),
                const SizedBox(width: Margins.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.primaryMediumBold.copyWith(color: titleColor),
                  ),
                ),
                if (!isExpanded && summary != null) ...[
                  summary!,
                  const SizedBox(width: Margins.spacingBase),
                ],
                isExpanded
                    ? Icon(
                        MingCuteIcons.mgc_minimize_line,
                        size: Dimens.iconSizeS,
                        color: AppColors.content(context),
                      )
                    : Icon(
                        MingCuteIcons.mgc_down_line,
                        size: Dimens.iconSizeS,
                        color: AppColors.contentSoft(context),
                      ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: AnimationDurations.base,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Padding(
                  key: ValueKey('expanded_$index'),
                  padding: const EdgeInsets.only(bottom: Margins.spacingM),
                  child: child,
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
        const SmallDivider(width: double.infinity),
      ],
    );
  }
}

class _FeelingSelector extends StatelessWidget {
  const _FeelingSelector({required this.value, required this.onChanged});

  final AverageFeeling? value;
  final ValueChanged<AverageFeeling> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.feelingSectionQuestion,
          style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoft(context)),
        ),
        const SizedBox(height: Margins.spacingBase),
        Row(
          spacing: Margins.spacingS,
          children: [
            for (final f in AverageFeeling.values)
              Expanded(
                child: _SquareChip(
                  selected: value == f,
                  onTap: () => onChanged(f),
                  icon: _feelingIcon(f),
                  label: f.label,
                ),
              ),
          ],
        ),
      ],
    );
  }

  static IconData _feelingIcon(AverageFeeling feeling) => switch (feeling) {
    AverageFeeling.rough => MingCuteIcons.mgc_sad_line,
    AverageFeeling.low => MingCuteIcons.mgc_confused_line,
    AverageFeeling.okey => MingCuteIcons.mgc_meh_line,
    AverageFeeling.good => MingCuteIcons.mgc_emoji_line,
    AverageFeeling.great => MingCuteIcons.mgc_happy_line,
  };
}

class _MeaningSelector extends StatelessWidget {
  const _MeaningSelector({required this.value, required this.onChanged});

  final MeaningScore? value;
  final ValueChanged<MeaningScore> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.meaningSectionQuestion,
          style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoft(context)),
        ),
        const SizedBox(height: Margins.spacingBase),
        Row(
          spacing: Margins.spacingS,
          children: [
            for (final m in MeaningScore.values)
              Expanded(
                child: _SquareChip(
                  selected: value == m,
                  onTap: () => onChanged(m),
                  iconBuilder: (color) => _MeaningBars(filled: m.filledBars, color: color),
                  label: m.label,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _NewExperienceSelector extends StatelessWidget {
  const _NewExperienceSelector({required this.value, required this.onChanged});

  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.newExperienceSectionQuestion,
          style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoft(context)),
        ),
        const SizedBox(height: Margins.spacingBase),
        Row(
          spacing: Margins.spacingBase,
          children: [
            Expanded(
              child: _PillChip(
                selected: value == false,
                onTap: () => onChanged(false),
                icon: MingCuteIcons.mgc_close_line,
                label: Strings.newExperienceSectionValueNo,
              ),
            ),
            Expanded(
              child: _PillChip(
                selected: value == true,
                onTap: () => onChanged(true),
                icon: MingCuteIcons.mgc_check_line,
                label: Strings.newExperienceSectionValueYes,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SquareChip extends StatelessWidget {
  const _SquareChip({
    required this.selected,
    required this.onTap,
    required this.label,
    this.icon,
    this.iconBuilder,
  }) : assert(icon != null || iconBuilder != null);

  final bool selected;
  final VoidCallback onTap;
  final String label;
  final IconData? icon;
  final Widget Function(Color color)? iconBuilder;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final iconFgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);
    final labelFgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    return GestureDetector(
      onTap: () {
        SensorialFeedback.selectionChanged();
        onTap();
      },
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: Margins.spacingBase),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Dimens.iconSizeBase,
              child: icon != null
                  ? Icon(icon, color: iconFgColor, size: Dimens.iconSizeBase)
                  : iconBuilder!(iconFgColor),
            ),
            const SizedBox(height: Margins.spacingS),
            Text(
              label,
              style: TextStyles.primaryXsBold.copyWith(color: labelFgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final iconFgColor = selected ? AppColors.contentMuted(context) : AppColors.contentSoftOnSoft(context);
    final labelFgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    return GestureDetector(
      onTap: () {
        SensorialFeedback.selectionChanged();
        onTap();
      },
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: Margins.spacingBase),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Dimens.radiusXl),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconFgColor, size: Dimens.iconSizeS),
            const SizedBox(width: Margins.spacingS),
            Text(
              label,
              style: TextStyles.primaryRegularBold.copyWith(color: labelFgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeaningBars extends StatelessWidget {
  const _MeaningBars({required this.filled, required this.color, this.size = Dimens.iconSizeBase});

  final int filled;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    const totalBars = 5;
    const baseHeight = 6.0;
    const heightStep = 4.0;

    return Transform.scale(
      scale: size / Dimens.iconSizeBase,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < totalBars; i++) ...[
            if (i < filled) ...[
              if (i > 0) const SizedBox(width: 3),
              Container(
                width: 3,
                height: baseHeight + heightStep * i,
                decoration: BoxDecoration(
                  color: i < filled ? color : color.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _FeelingSummary extends StatelessWidget {
  const _FeelingSummary({required this.value});

  final AverageFeeling value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _FeelingSelector._feelingIcon(value),
          size: Dimens.iconSizeXs,
          color: AppColors.content(context),
        ),
        const SizedBox(width: Margins.spacingS),
        Text(
          value.label,
          style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
        ),
      ],
    );
  }
}

class _MeaningSummary extends StatelessWidget {
  const _MeaningSummary({required this.value});

  final MeaningScore value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MeaningBars(filled: value.filledBars, color: AppColors.content(context), size: Dimens.iconSizeXs),
        const SizedBox(width: Margins.spacingS),
        Text(
          value.label,
          style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
        ),
      ],
    );
  }
}

class _NewExperienceSummary extends StatelessWidget {
  const _NewExperienceSummary({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value ? Strings.newExperienceSectionValueYes : Strings.newExperienceSectionValueNo,
      style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
    );
  }
}

class _LivingIntentionsSelector extends StatelessWidget {
  const _LivingIntentionsSelector({
    required this.value,
    required this.onToggle,
    required this.onAllSelected,
  });

  final Set<String> value;
  final ValueChanged<String> onToggle;
  final VoidCallback onAllSelected;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) {
        final weeklyState = store.state.weeklyIntentState;
        return weeklyState.availableIntents.where((i) => weeklyState.selectedIds.contains(i.id)).toList();
      },
      builder: (context, weeklyIntents) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.livingIntentionsSectionQuestion,
              style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoft(context)),
            ),
            const SizedBox(height: Margins.spacingBase),
            Wrap(
              spacing: Margins.spacingS,
              runSpacing: Margins.spacingS,
              children: [
                for (final intent in weeklyIntents)
                  _IntentPillChip(
                    selected: value.contains(intent.id),
                    onTap: () {
                      SensorialFeedback.selectionChanged();
                      final willBeSelected = !value.contains(intent.id);
                      onToggle(intent.id);
                      if (willBeSelected && value.length + 1 == weeklyIntents.length) {
                        onAllSelected();
                      }
                    },
                    label: intent.label,
                  ),
              ],
            ),
            TextButton(
              onPressed: () {
                SensorialFeedback.selectionChanged();
                EditWeeklyIntentBottomSheet.show(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.livingIntentionsSectionEditLabel,
                    style: TextStyles.primarySmallBold.copyWith(color: AppColors.contentSoft(context)),
                  ),
                  const SizedBox(width: Margins.spacingXs),
                  Icon(
                    MingCuteIcons.mgc_right_line,
                    size: Dimens.iconSizeXs,
                    color: AppColors.contentSoft(context),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LivingIntentionsSummary extends StatelessWidget {
  const _LivingIntentionsSummary({required this.selectedIds});

  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) => store.state.weeklyIntentState.availableIntents,
      builder: (context, intents) {
        final labels = selectedIds.map((id) => intents.firstWhere((i) => i.id == id).label).join(', ');
        return Text(
          labels,
          style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

class _IntentPillChip extends StatelessWidget {
  const _IntentPillChip({required this.selected, required this.onTap, required this.label});

  final bool selected;
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    final Widget leading;
    if (selected) {
      leading = _SelectedIntentDot(color: fgColor);
    } else {
      leading = _DashedCircle(color: AppColors.contentSoftOnSoft(context), size: 16);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AnimationDurations.short,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingS + Margins.spacingXs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Dimens.radiusXl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: Margins.spacingS),
            Text(
              label,
              style: TextStyles.primarySmallBold.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedIntentDot extends StatelessWidget {
  const _SelectedIntentDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.iconSizeXs,
      height: Dimens.iconSizeXs,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        MingCuteIcons.mgc_check_line,
        size: 12,
        color: AppColors.content(context),
      ),
    );
  }
}

class _DashedCircle extends StatelessWidget {
  const _DashedCircle({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedCirclePainter(color: color),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - paint.strokeWidth / 2;

    const dashCount = 8;
    const sweepPerDash = (2 * math.pi) / dashCount;
    const dashSweep = sweepPerDash * 0.55;

    for (int i = 0; i < dashCount; i++) {
      final start = i * sweepPerDash;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) => oldDelegate.color != color;
}

class _LeaveATraceSummary extends StatelessWidget {
  const _LeaveATraceSummary({required this.value});

  final LeaveATrace value;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (value.text.isNotEmpty) parts.add('…');
    if (value.imagePaths.isNotEmpty) {
      parts.add(Strings.leaveATraceSectionPhotoCount(value.imagePaths.length));
    }
    return Text(
      parts.join(' '),
      style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _LeaveATraceInput extends StatefulWidget {
  const _LeaveATraceInput({required this.value, required this.onChanged});

  final LeaveATrace value;
  final ValueChanged<LeaveATrace> onChanged;

  @override
  State<_LeaveATraceInput> createState() => _LeaveATraceInputState();
}

class _LeaveATraceInputState extends State<_LeaveATraceInput> {
  late final TextEditingController _textController;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _openTextEditor() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _TextEditorPage(initialText: _textController.text),
      ),
    );
    if (result != null) {
      _textController.text = result;
      widget.onChanged(widget.value.copyWith(text: result));
    }
  }

  Future<void> _pickImages() async {
    final remaining = LeaveATrace.maxImages - widget.value.imagePaths.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage(limit: remaining);
    if (picked.isEmpty) return;

    final paths = [...widget.value.imagePaths, ...picked.map((f) => f.path)];
    widget.onChanged(widget.value.copyWith(imagePaths: paths));
  }

  Future<void> _replaceImages() async {
    final picked = await _picker.pickMultiImage(limit: LeaveATrace.maxImages);
    if (picked.isEmpty) return;

    widget.onChanged(widget.value.copyWith(imagePaths: picked.map((f) => f.path).toList()));
  }

  void _removeImage(int index) {
    final paths = [...widget.value.imagePaths]..removeAt(index);
    widget.onChanged(widget.value.copyWith(imagePaths: paths));
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.value.imagePaths;
    final canAddMore = images.length < LeaveATrace.maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.leaveATraceSectionSubtitle,
          style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.contentSoft(context)),
        ),
        const SizedBox(height: Margins.spacingBase),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Hero(
                  tag: 'leaveATraceTextEditor',
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgSoft(context),
                      borderRadius: BorderRadius.circular(Dimens.radiusBase),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Margins.spacingBase,
                      vertical: Margins.spacingS,
                    ),
                    child: TextField(
                      onTap: _openTextEditor,
                      readOnly: true,
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyles.primaryXsBold.copyWith(color: AppColors.content(context)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.leaveATraceSectionTextHint,
                        hintStyle: TextStyles.primaryXsBold.copyWith(
                          color: AppColors.contentSoft(context),
                        ),
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Margins.spacingS),
              Container(
                width: 1,
                color: AppColors.strokeColor(context),
              ),
              const SizedBox(width: Margins.spacingS),
              Expanded(
                child: _ImageMosaic(
                  images: images,
                  canAddMore: canAddMore,
                  onAdd: _pickImages,
                  onReplace: _replaceImages,
                  onRemove: _removeImage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageMosaic extends StatelessWidget {
  const _ImageMosaic({
    required this.images,
    required this.canAddMore,
    required this.onAdd,
    required this.onReplace,
    required this.onRemove,
  });

  final List<String> images;
  final bool canAddMore;
  final VoidCallback onAdd;
  final VoidCallback onReplace;
  final ValueChanged<int> onRemove;

  static const double _gap = Margins.spacingXs;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        child: _AddPhotoButton(onTap: onAdd),
      );
    }

    return GestureDetector(
      onTap: () {
        SensorialFeedback.selectionChanged();
        onReplace();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        child: _buildGrid(),
      ),
    );
  }

  Widget _buildGrid() {
    return switch (images.length) {
      1 => _MosaicImage(path: images[0]),
      2 => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _MosaicImage(path: images[0])),
          const SizedBox(width: _gap),
          Expanded(child: _MosaicImage(path: images[1])),
        ],
      ),
      _ => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _MosaicImage(path: images[0])),
          const SizedBox(width: _gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _MosaicImage(path: images[1])),
                const SizedBox(height: _gap),
                Expanded(child: _MosaicImage(path: images[2])),
              ],
            ),
          ),
        ],
      ),
    };
  }
}

class _MosaicImage extends StatelessWidget {
  const _MosaicImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
    );
  }
}

class _TextEditorPage extends StatefulWidget {
  const _TextEditorPage({required this.initialText});

  final String initialText;

  @override
  State<_TextEditorPage> createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<_TextEditorPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),

      appBar: AppBar(
        backgroundColor: AppColors.bg(context),
        leading: const CloseButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Margins.spacingBase),
            Text(
              Strings.leaveATraceSectionQuestion,
              style: TextStyles.primaryLargeMedium.copyWith(color: AppColors.content(context)),
            ),
            const SizedBox(height: Margins.spacingBase),
            Expanded(
              child: Hero(
                tag: 'leaveATraceTextEditor',
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Margins.spacingBase,
                    vertical: Margins.spacingS,
                  ),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.bgSoft(context),
                    borderRadius: BorderRadius.circular(Dimens.radiusBase),
                  ),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyles.primaryRegularMedium.copyWith(color: AppColors.content(context)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Strings.leaveATraceSectionTextHint,
                      hintStyle: TextStyles.primaryRegularMedium.copyWith(
                        color: AppColors.contentSoft(context),
                      ),
                      isCollapsed: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Margins.spacingBase),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: Strings.done,
                onPressed: _confirm,
              ),
            ),
            const SizedBox(height: Margins.spacingBase),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SensorialFeedback.selectionChanged();
        onTap();
      },
      child: Container(
        color: AppColors.bgSoft(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/add_images.svg",
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(AppColors.contentSoft(context), BlendMode.srcIn),
            ),
            const SizedBox(height: Margins.spacingXs),
            Text(
              Strings.leaveATraceSectionAddPhoto,
              style: TextStyles.primaryXsBold.copyWith(color: AppColors.contentSoft(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
