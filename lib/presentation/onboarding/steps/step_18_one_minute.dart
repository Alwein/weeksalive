import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step18OneMinute extends OnboardingStep {
  const Step18OneMinute();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: Margins.spacingS),
                Texts.xlBold(Strings.onboarding18Title),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryRegularSoft(context, Strings.onboarding18Subtitle),
                const SizedBox(height: Margins.spacingM),
                const Expanded(
                  child: Center(
                    child: _WeekCard(),
                  ),
                ),
                const SizedBox(height: Margins.spacingM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const double _kBaseCircleSize = 6;
const double _kMaxStepCircleContribution = 6;

double _proportionalContribution(int index, int valueCount) => index / (valueCount - 1) * _kMaxStepCircleContribution;

double _demoCircleSize({
  required AverageFeeling? feeling,
  required MeaningScore? meaning,
  required bool? hasNewExperience,
  required Set<_DemoIntent> intents,
}) {
  final feelingContribution = feeling != null
      ? _proportionalContribution(feeling.index, AverageFeeling.values.length)
      : 0.0;
  final meaningContribution = meaning != null
      ? _proportionalContribution(meaning.index, MeaningScore.values.length)
      : 0.0;
  final newExperienceContribution = hasNewExperience == true ? _kMaxStepCircleContribution : 0.0;
  final intentionContribution = intents.isNotEmpty ? _kMaxStepCircleContribution : 0.0;

  return _kBaseCircleSize +
      feelingContribution +
      meaningContribution +
      newExperienceContribution +
      intentionContribution;
}

class _WeekCard extends StatefulWidget {
  const _WeekCard();

  @override
  State<_WeekCard> createState() => _WeekCardState();
}

class _WeekCardState extends State<_WeekCard> {
  AverageFeeling? _feeling;
  MeaningScore? _meaning;
  bool? _hasNewExperience;
  final Set<_DemoIntent> _intents = {};

  _DemoSection _expanded = _DemoSection.feeling;

  double get _circleSize => _demoCircleSize(
    feeling: _feeling,
    meaning: _meaning,
    hasNewExperience: _hasNewExperience,
    intents: _intents,
  );

  void _onSectionTap(_DemoSection section) {
    setState(() => _expanded = section);
  }

  Future<void> _advanceToNextSection(_DemoSection from) async {
    final nextIndex = from.index + 1;
    if (nextIndex >= _DemoSection.values.length) return;

    await Future<void>.delayed(AnimationDurations.short);
    if (!mounted) return;
    setState(() => _expanded = _DemoSection.values[nextIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WeekHeader(circleSize: _circleSize),
          _buildFormDemo(),
        ],
      ),
    );
  }

  Widget _buildFormDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DemoSectionTile(
          index: '01',
          title: Strings.feelingSectionTitle,
          isExpanded: _expanded == _DemoSection.feeling,
          summary: _feeling != null ? _FeelingSummary(value: _feeling!) : null,
          onTap: () => _onSectionTap(_DemoSection.feeling),
          child: _FeelingSelector(
            value: _feeling,
            onChanged: (v) {
              SensorialFeedback.selectionChanged();
              final wasUnanswered = _feeling == null;
              setState(() => _feeling = v);
              if (wasUnanswered) _advanceToNextSection(_DemoSection.feeling);
            },
          ),
        ),
        const _Divider(),
        _DemoSectionTile(
          index: '02',
          title: Strings.meaningSectionTitle,
          isExpanded: _expanded == _DemoSection.meaning,
          summary: _meaning != null ? _MeaningSummary(value: _meaning!) : null,
          onTap: () => _onSectionTap(_DemoSection.meaning),
          child: _MeaningSelector(
            value: _meaning,
            onChanged: (v) {
              SensorialFeedback.selectionChanged();
              final wasUnanswered = _meaning == null;
              setState(() => _meaning = v);
              if (wasUnanswered) _advanceToNextSection(_DemoSection.meaning);
            },
          ),
        ),
        const _Divider(),
        _DemoSectionTile(
          index: '03',
          title: Strings.newExperienceSectionTitle,
          isExpanded: _expanded == _DemoSection.newExperience,
          summary: _hasNewExperience != null ? _NewExperienceSummary(value: _hasNewExperience!) : null,
          onTap: () => _onSectionTap(_DemoSection.newExperience),
          child: _NewExperienceSelector(
            value: _hasNewExperience,
            onChanged: (v) {
              SensorialFeedback.selectionChanged();
              final wasUnanswered = _hasNewExperience == null;
              setState(() => _hasNewExperience = v);
              if (wasUnanswered) _advanceToNextSection(_DemoSection.newExperience);
            },
          ),
        ),
        const _Divider(),
        _DemoSectionTile(
          index: '04',
          title: Strings.livingIntentionsSectionTitle,
          isExpanded: _expanded == _DemoSection.intention,
          summary: _intents.isNotEmpty ? _IntentionSummary(values: _intents) : null,
          onTap: () => _onSectionTap(_DemoSection.intention),
          child: _IntentionSelector(
            values: _intents,
            onToggle: (intent) {
              SensorialFeedback.selectionChanged();
              setState(() {
                if (_intents.contains(intent)) {
                  _intents.remove(intent);
                } else {
                  _intents.add(intent);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.circleSize});

  final double circleSize;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      color: AppColors.bgSoft(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          const SizedBox(width: Margins.spacingBase),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: Margins.spacingS),
                    Expanded(child: Texts.primaryLargeBold(TimeUtils.formatDate(context, DateTime.now()))),
                    Texts.primaryXsCounter(
                      context,
                      Strings.dayLabel,
                      "#${controller.totalDaysLived.toString()}",
                      softColor: AppColors.contentSoftOnSoft(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _DemoSection { feeling, meaning, newExperience, intention }

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
      height: 1,
      width: double.infinity,
      color: AppColors.strokeColor(context),
    );
  }
}

class _DemoSectionTile extends StatelessWidget {
  const _DemoSectionTile({
    required this.index,
    required this.title,
    required this.isExpanded,
    required this.summary,
    required this.onTap,
    required this.child,
  });

  final String index;
  final String title;
  final bool isExpanded;
  final Widget? summary;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = isExpanded ? AppColors.content(context) : AppColors.contentSoftOnSoft(context);
    final Color indexColor = AppColors.contentExtraSoft(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Margins.spacingBase,
              vertical: Margins.spacingBase,
            ),
            child: Row(
              children: [
                Text(index, style: TextStyles.primaryRegularBold.copyWith(color: indexColor)),
                const SizedBox(width: Margins.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.primaryRegularBold.copyWith(color: titleColor),
                  ),
                ),
                if (!isExpanded && summary != null) ...[
                  summary!,
                  const SizedBox(width: Margins.spacingS),
                ],
                if (isExpanded)
                  Icon(
                    MingCuteIcons.mgc_minimize_line,
                    size: Dimens.iconSizeXs,
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
                  padding: const EdgeInsets.fromLTRB(
                    Margins.spacingBase,
                    0,
                    Margins.spacingBase,
                    Margins.spacingBase,
                  ),
                  child: child,
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }
}

IconData _feelingIcon(AverageFeeling feeling) => switch (feeling) {
  AverageFeeling.rough => MingCuteIcons.mgc_sad_line,
  AverageFeeling.low => MingCuteIcons.mgc_confused_line,
  AverageFeeling.okey => MingCuteIcons.mgc_meh_line,
  AverageFeeling.good => MingCuteIcons.mgc_emoji_line,
  AverageFeeling.great => MingCuteIcons.mgc_happy_line,
};

class _FeelingSelector extends StatelessWidget {
  const _FeelingSelector({required this.value, required this.onChanged});

  final AverageFeeling? value;
  final ValueChanged<AverageFeeling> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularSoft(context, Strings.feelingSectionQuestion),
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
        Texts.primaryRegularSoft(context, Strings.meaningSectionQuestion),
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
        Texts.primaryRegularSoft(context, Strings.newExperienceSectionQuestion),
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

enum _DemoIntent {
  bePresent,
  explore,
  connect;

  String get label => switch (this) {
    _DemoIntent.bePresent => Strings.intentBePresent,
    _DemoIntent.explore => Strings.intentExplore,
    _DemoIntent.connect => Strings.intentConnect,
  };

  String get summaryLabel => switch (this) {
    _DemoIntent.bePresent => Strings.livingIntentionsSectionValueBePresent,
    _DemoIntent.explore => Strings.livingIntentionsSectionValueExplore,
    _DemoIntent.connect => Strings.livingIntentionsSectionValueConnect,
  };
}

class _IntentionSelector extends StatelessWidget {
  const _IntentionSelector({required this.values, required this.onToggle});

  final Set<_DemoIntent> values;
  final ValueChanged<_DemoIntent> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Texts.primaryRegularSoft(context, Strings.livingIntentionsSectionQuestion),
        const SizedBox(height: Margins.spacingBase),
        Wrap(
          spacing: Margins.spacingS,
          runSpacing: Margins.spacingS,
          children: [
            for (final intent in _DemoIntent.values)
              _IntentPillChip(
                selected: values.contains(intent),
                onTap: () => onToggle(intent),
                label: intent.label,
              ),
            _IntentPillChip(
              selected: false,
              onTap: null,
              label: Strings.livingIntentionsSectionValueNone,
            ),
            _IntentPillChip(
              selected: false,
              onTap: null,
              icon: MingCuteIcons.mgc_pencil_line,
              label: Strings.livingIntentionsSectionEditLabel,
              hideLeading: true,
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
      onTap: onTap,
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
      onTap: onTap,
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

class _IntentPillChip extends StatelessWidget {
  const _IntentPillChip({
    required this.selected,
    required this.onTap,
    required this.label,
    this.icon,
    this.hideLeading = false,
  });

  final bool selected;
  final VoidCallback? onTap;
  final String label;
  final IconData? icon;
  final bool hideLeading;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    final Widget leading;
    if (hideLeading && icon != null) {
      leading = Icon(icon, color: fgColor, size: Dimens.iconSizeXs);
    } else if (selected) {
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
      width: 16,
      height: 16,
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

    const dashCount = 10;
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
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => oldDelegate.color != color;
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
        Icon(_feelingIcon(value), size: Dimens.iconSizeXs, color: AppColors.content(context)),
        const SizedBox(width: Margins.spacingS),
        Texts.primaryXsBold(value.label),
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
        Texts.primaryXsBold(value.label),
      ],
    );
  }
}

class _NewExperienceSummary extends StatelessWidget {
  const _NewExperienceSummary({required this.value});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Texts.primaryXsBold(
      value ? Strings.newExperienceSectionValueYes : Strings.newExperienceSectionValueNo,
    );
  }
}

class _IntentionSummary extends StatelessWidget {
  const _IntentionSummary({required this.values});
  final Set<_DemoIntent> values;

  @override
  Widget build(BuildContext context) {
    final text = values.isEmpty ? "—" : values.map((e) => e.summaryLabel).join(", ");
    return Texts.primaryXsBold(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
