import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_actions.dart';
import 'package:weeksalive/presentation/redux/weekly_intent/widgets/weekly_intent_form_content.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class EditWeeklyIntentBottomSheet extends StatefulWidget {
  const EditWeeklyIntentBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => const EditWeeklyIntentBottomSheet(),
      useRootNavigator: true,
    );
  }

  @override
  State<EditWeeklyIntentBottomSheet> createState() => _EditWeeklyIntentBottomSheetState();
}

class _EditWeeklyIntentBottomSheetState extends State<EditWeeklyIntentBottomSheet> {
  late final WeeklyIntentFormController _controller;

  @override
  void initState() {
    super.initState();
    final selectedIds = StoreProvider.of<AppState>(context, listen: false).state.weeklyIntentState.selectedIds;
    _controller = WeeklyIntentFormController(initialSelectedIds: selectedIds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDone() {
    StoreProvider.of<AppState>(context, listen: false).dispatch(
      SetWeeklyIntentSelectionAction(_controller.selectedIntentIds.toList()),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WeeklyIntentForm(controller: _controller),
          const SizedBox(height: Margins.spacingL),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: Strings.done,
                  onPressed: _controller.hasSelection ? _onDone : null,
                ),
              );
            },
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _WeeklyIntentForm extends StatelessWidget {
  const _WeeklyIntentForm({required this.controller});

  final WeeklyIntentFormController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Texts.xlBold(Strings.onboardingWeeklyIntentTitle),
            const SizedBox(height: Margins.spacingS),
            Texts.primaryMediumSoft(context, Strings.onboardingWeeklyIntentSubtitle),
            const SizedBox(height: Margins.spacingL),
            WeeklyIntentFormContent(
              selectedIds: controller.selectedIntentIds,
              onIntentToggled: controller.toggleIntent,
            ),
          ],
        );
      },
    );
  }
}

class WeeklyIntentFormController extends ChangeNotifier {
  WeeklyIntentFormController({
    Iterable<String> initialSelectedIds = const [],
    this.maxSelections = 3,
  }) : _selectedIntentIds = {...initialSelectedIds};

  final int maxSelections;
  final Set<String> _selectedIntentIds;

  Set<String> get selectedIntentIds => Set.unmodifiable(_selectedIntentIds);

  bool get hasSelection => _selectedIntentIds.isNotEmpty;

  void toggleIntent(String intentId) {
    if (_selectedIntentIds.contains(intentId)) {
      _selectedIntentIds.remove(intentId);
    } else if (_selectedIntentIds.length < maxSelections) {
      _selectedIntentIds.add(intentId);
    }
    notifyListeners();
  }
}
