import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step22WeeklyIntent extends OnboardingStep {
  const Step22WeeklyIntent();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  Widget buildContent(BuildContext context) => const _Step22Content();
}

class _Step22Content extends StatefulWidget {
  const _Step22Content();

  @override
  State<_Step22Content> createState() => _Step22ContentState();
}

class _Step22ContentState extends State<_Step22Content> {
  late List<WeeklyIntent> _intents;

  @override
  void initState() {
    super.initState();
    _intents = List.of(kDefaultWeeklyIntents);
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Texts.xlBold(Strings.onboardingWeeklyIntentTitle),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryMediumSoft(context, Strings.onboardingWeeklyIntentSubtitle),
                const SizedBox(height: Margins.spacingL),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final selectedIds = controller.selectedIntentIds;
                    return Wrap(
                      spacing: Margins.spacingS,
                      runSpacing: Margins.spacingS,
                      children: [
                        for (final intent in _intents)
                          _IntentChip(
                            label: intent.label.toUpperCase(),
                            selected: selectedIds.contains(intent.id),
                            onTap: () {
                              SensorialFeedback.selectionChanged();
                              controller.toggleIntent(intent.id);
                            },
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: Margins.spacingL),
                Center(
                  child: _EditButton(
                    onTap: () => _showEditSheet(context, controller.selectedIntentIds),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SmallDivider(),
                const SizedBox(height: Margins.spacingM),
                Texts.primaryMediumSoft(context, Strings.onboardingWeeklyIntentFooter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, Set<String> selectedIds) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _EditIntentsSheet(
          intents: _intents,
          selectedIds: selectedIds,
          onUpdate: (updatedIntents) {
            setState(() => _intents = updatedIntents);
          },
        );
      },
    );
  }
}

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? AppColors.content(context) : AppColors.bgSoft(context);
    final fgColor = selected ? AppColors.contentMuted(context) : AppColors.content(context);

    final Widget leading = selected
        ? _SelectedIntentDot(color: fgColor)
        : _DashedCircle(color: AppColors.contentSoftOnSoft(context), size: 16);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
  bool shouldRepaint(_DashedCirclePainter oldDelegate) => oldDelegate.color != color;
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingM,
          vertical: Margins.spacingS + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgSoft(context),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MingCuteIcons.mgc_pencil_line,
              size: 16,
              color: AppColors.contentSoftOnSoft(context),
            ),
            const SizedBox(width: 6),
            Texts.primaryXsMedium(
              'Edit',
              color: AppColors.contentSoftOnSoft(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditIntentsSheet extends StatefulWidget {
  const _EditIntentsSheet({
    required this.intents,
    required this.selectedIds,
    required this.onUpdate,
  });

  final List<WeeklyIntent> intents;
  final Set<String> selectedIds;
  final ValueChanged<List<WeeklyIntent>> onUpdate;

  @override
  State<_EditIntentsSheet> createState() => _EditIntentsSheetState();
}

class _EditIntentsSheetState extends State<_EditIntentsSheet> {
  late List<WeeklyIntent> _intents;
  final _textController = TextEditingController();
  bool _showAddField = false;

  @override
  void initState() {
    super.initState();
    _intents = List.of(widget.intents);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addCustomIntent() {
    final label = _textController.text.trim();
    if (label.isEmpty) return;
    setState(() {
      _intents.add(WeeklyIntent(id: label.toLowerCase().replaceAll(' ', '_'), label: label));
      _textController.clear();
      _showAddField = false;
    });
    widget.onUpdate(_intents);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Margins.spacingM,
          Margins.spacingM,
          Margins.spacingM,
          Margins.spacingL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.contentExtraSoft(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: Margins.spacingM),
            Texts.primaryMediumBold('Your intentions'),
            const SizedBox(height: Margins.spacingBase),
            Wrap(
              spacing: Margins.spacingS,
              runSpacing: Margins.spacingS,
              children: [
                for (final intent in _intents)
                  _EditableIntentChip(
                    label: intent.label.toUpperCase(),
                    isDefault: kDefaultWeeklyIntents.any((d) => d.label == intent.label),
                    onRemove: () {
                      setState(() => _intents.remove(intent));
                      widget.onUpdate(_intents);
                    },
                  ),
              ],
            ),
            const SizedBox(height: Margins.spacingM),
            if (_showAddField) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'New intention…',
                        hintStyle: TextStyle(color: AppColors.contentSoft(context)),
                        filled: true,
                        fillColor: AppColors.bgSoft(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Margins.spacingBase,
                          vertical: Margins.spacingS,
                        ),
                      ),
                      onSubmitted: (_) => _addCustomIntent(),
                    ),
                  ),
                  const SizedBox(width: Margins.spacingS),
                  GestureDetector(
                    onTap: _addCustomIntent,
                    child: Container(
                      padding: const EdgeInsets.all(Margins.spacingS),
                      decoration: BoxDecoration(
                        color: AppColors.content(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        MingCuteIcons.mgc_check_fill,
                        size: 20,
                        color: AppColors.contentMuted(context),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              GestureDetector(
                onTap: () => setState(() => _showAddField = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Margins.spacingBase,
                    vertical: Margins.spacingS + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgSoft(context),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MingCuteIcons.mgc_add_fill,
                        size: 14,
                        color: AppColors.contentSoftOnSoft(context),
                      ),
                      const SizedBox(width: 6),
                      Texts.primaryXsMedium(
                        'Add',
                        color: AppColors.contentSoftOnSoft(context),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Margins.spacingBase),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Margins.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.content(context),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Texts.primaryMedium(
                    Strings.done,
                    color: AppColors.contentMuted(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableIntentChip extends StatelessWidget {
  const _EditableIntentChip({
    required this.label,
    required this.isDefault,
    required this.onRemove,
  });

  final String label;
  final bool isDefault;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Margins.spacingBase,
        vertical: Margins.spacingS + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Texts.primaryXsMedium(label, color: AppColors.contentSoftOnSoft(context)),
          if (!isDefault) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                SensorialFeedback.selectionChanged();
                onRemove();
              },
              child: Icon(
                MingCuteIcons.mgc_close_fill,
                size: 14,
                color: AppColors.contentSoft(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
