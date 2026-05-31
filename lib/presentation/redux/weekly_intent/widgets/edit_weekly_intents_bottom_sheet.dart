import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/weekly_intent/weekly_intent.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class EditIntentsSheet extends StatefulWidget {
  const EditIntentsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => const EditIntentsSheet(),
    );
  }

  @override
  State<EditIntentsSheet> createState() => _EditIntentsSheetState();
}

class _EditIntentsSheetState extends State<EditIntentsSheet> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WeeklyIntent>>(
      converter: (store) => store.state.weeklyIntentState.availableIntents,
      builder: (context, intents) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Texts.primaryMediumBold(Strings.editWeeklyIntentsTitle),
              const SizedBox(height: Margins.spacingBase),
              Wrap(
                spacing: Margins.spacingS,
                runSpacing: Margins.spacingS,
                children: [
                  for (final intent in intents)
                    _EditableIntentChip(
                      label: intent.label,
                      onRemove: () => StoreProvider.of<AppState>(context).dispatch(RemoveWeeklyIntentAction(intent.id)),
                    ),
                ],
              ),
              const SizedBox(height: Margins.spacingM),
              const SmallDivider(width: double.infinity),
              const SizedBox(height: Margins.spacingM),
              Texts.primaryXsCounter(context, Strings.editWeeklyIntentsAddCustomLabel, null),
              const SizedBox(height: Margins.spacingS),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: Strings.editWeeklyIntentsCustomHint,
                        hintStyle: TextStyle(color: AppColors.contentSoft(context)),
                        filled: true,
                        fillColor: AppColors.bgSoft(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Margins.spacingBase,
                          vertical: Margins.spacingBase,
                        ),
                      ),
                      onSubmitted: (_) {},
                    ),
                  ),
                  const SizedBox(width: Margins.spacingS),
                  PrimaryButton(
                    text: Strings.editWeeklyIntentsAdd,
                    onPressed: _textController.text.isNotEmpty
                        ? () {
                            StoreProvider.of<AppState>(context).dispatch(AddWeeklyIntentAction(_textController.text));
                            _textController.clear();
                          }
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: Margins.spacingM),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: Strings.done,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: Margins.spacingM),
            ],
          ),
        );
      },
    );
  }
}

class _EditableIntentChip extends StatelessWidget {
  const _EditableIntentChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSoft(context),
      borderRadius: BorderRadius.circular(Dimens.radiusXl),
      child: InkWell(
        onTap: () {
          SensorialFeedback.selectionChanged();
          onRemove();
        },
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacingBase),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Texts.primaryXsMedium(label, color: AppColors.content(context)),
              const SizedBox(width: Margins.spacingS),
              Icon(
                MingCuteIcons.mgc_close_fill,
                size: 14,
                color: AppColors.content(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
