import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/day_form/day_form_confirmation_page.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/secondary_button.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// Result returned by the day form sheet once it closes after a save.
///
/// Used by the home page to orchestrate the post-save animations (year grid
/// dot scale-in, then the streak reveal in the app bar).
class DayFormResult {
  const DayFormResult({
    required this.date,
    required this.sizeLevel,
    required this.previousStreak,
    required this.newStreak,
  });

  final DateTime date;
  final int sizeLevel;
  final int previousStreak;
  final int newStreak;

  bool get streakIncreased => newStreak > previousStreak;
}

Future<DayFormResult?> showDayFormSheet(
  BuildContext context,
  DateTime date, {
  void Function(DayFormResult result)? onDaySaved,
}) {
  final controller = SheetController();

  final fullscreenAnimation = SheetOffsetDrivenAnimation(
    controller: controller,
    initialValue: 0,
    startOffset: const SheetOffset(1),
    endOffset: const SheetOffset.proportionalToViewport(1),
  );

  return Navigator.of(context).push(
    ModalSheetRoute<DayFormResult>(
      swipeDismissible: true,
      builder: (context) => _DayFormSheetRoot(
        date: date,
        controller: controller,
        fullscreenAnimation: fullscreenAnimation,
        onDaySaved: onDaySaved,
      ),
    ),
  );
}

class _DayFormSheetRoot extends StatefulWidget {
  const _DayFormSheetRoot({
    required this.date,
    required this.controller,
    required this.fullscreenAnimation,
    this.onDaySaved,
  });

  final DateTime date;
  final SheetController controller;
  final Animation<double> fullscreenAnimation;
  final void Function(DayFormResult result)? onDaySaved;

  @override
  State<_DayFormSheetRoot> createState() => _DayFormSheetRootState();
}

class _DayFormSheetRootState extends State<_DayFormSheetRoot> {
  final _canSave = ValueNotifier<bool>(false);
  final _heroController = HeroController();

  DayFormResult? _result;

  late final Navigator _nestedNavigator;

  @override
  void initState() {
    super.initState();
    _nestedNavigator = Navigator(
      observers: [_heroController],
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          PagedSheetRoute<void>(
            initialOffset: const SheetOffset(1),
            snapGrid: const MultiSnapGrid(
              snaps: [SheetOffset(1), SheetOffset.proportionalToViewport(1)],
            ),
            builder: (context) => _DayFormPage(
              date: widget.date,
              fullscreenAnimation: widget.fullscreenAnimation,
              canSave: _canSave,
              onClose: _closeSheet,
              onSaved: (result) {
                _result = result;
                widget.onDaySaved?.call(result);
              },
            ),
          ),
        ];
      },
    );
  }

  @override
  void dispose() {
    _canSave.dispose();
    _heroController.dispose();
    super.dispose();
  }

  void _closeSheet() => Navigator.of(context, rootNavigator: true).pop(_result);

  Future<void> _onAttemptDismiss() async {
    if (!_canSave.value) {
      _closeSheet();
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _CloseConfirmationDialog(dialogContext: dialogContext),
    );

    if (discard == true) _closeSheet();
  }

  @override
  Widget build(BuildContext context) {
    return SheetPopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onAttemptDismiss();
      },
      child: PagedSheet(
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
      ),
    );
  }
}

class _CloseConfirmationDialog extends StatelessWidget {
  const _CloseConfirmationDialog({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        side: BorderSide(color: AppColors.strokeColor(context)),
      ),
      backgroundColor: AppColors.bg(context),
      title: Texts.primaryMediumBold(Strings.dayFormDiscardTitle),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              text: Strings.dayFormDiscardCancel,
            ),
            const SizedBox(height: Margins.spacingS),
            SecondaryButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              text: Strings.dayFormDiscardConfirm,
            ),
          ],
        ),
      ],
    );
  }
}

class _DayFormPage extends StatelessWidget {
  const _DayFormPage({
    required this.date,
    required this.fullscreenAnimation,
    required this.canSave,
    required this.onClose,
    required this.onSaved,
  });

  final DateTime date;
  final Animation<double> fullscreenAnimation;
  final ValueNotifier<bool> canSave;
  final VoidCallback onClose;
  final ValueChanged<DayFormResult> onSaved;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayFormViewModel>(
      converter: (store) => DayFormViewModel.create(store, date),
      builder: (context, viewModel) => _DayFormPageContent(
        viewModel: viewModel,
        date: date,
        fullscreenAnimation: fullscreenAnimation,
        canSave: canSave,
        onClose: onClose,
        onSaved: onSaved,
      ),
    );
  }
}

class _DayFormPageContent extends StatefulWidget {
  const _DayFormPageContent({
    required this.viewModel,
    required this.date,
    required this.fullscreenAnimation,
    required this.canSave,
    required this.onClose,
    required this.onSaved,
  });

  final DayFormViewModel viewModel;
  final DateTime date;
  final Animation<double> fullscreenAnimation;
  final ValueNotifier<bool> canSave;
  final VoidCallback onClose;
  final ValueChanged<DayFormResult> onSaved;

  @override
  State<_DayFormPageContent> createState() => _DayFormPageContentState();
}

class _DayFormPageContentState extends State<_DayFormPageContent> {
  late final DayFormController _controller;
  bool _saved = false;

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

  void _onControllerChanged() {
    if (!_saved) widget.canSave.value = _controller.canSave;
    setState(() {});
  }

  void _goToConfirmation() {
    final entry = _controller.buildEntry(widget.date);
    final store = StoreProvider.of<AppState>(context);
    final previousStreak = store.state.streakState.count;
    store.dispatch(SaveDayAction(entry));
    // The streak is refreshed asynchronously by the middleware, so compute it
    // synchronously from the (already updated) day state to know the new value.
    final newStreak = computeStreak(
      store.state.dayState.entries.keys.toSet(),
      DateTime.now(),
    );
    _saved = true;
    widget.canSave.value = false;

    widget.onSaved(
      DayFormResult(
        date: entry.date,
        sizeLevel: entry.sizeLevel,
        previousStreak: previousStreak,
        newStreak: newStreak,
      ),
    );

    final isFirstEntry = widget.viewModel.existingEntry == null;

    Navigator.of(context).push(
      PagedSheetRoute<void>(
        builder: (_) => DayFormConfirmationPage(
          entry: entry,
          isFirstEntry: isFirstEntry,
          onClose: widget.onClose,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.viewPaddingOf(context).top;

    return SheetContentScaffold(
      backgroundColor: AppColors.bg(context),
      topBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: widget.fullscreenAnimation,
            builder: (context, _) => SizedBox(
              height: topPadding * widget.fullscreenAnimation.value,
            ),
          ),
          _DayFormTopBar(
            animation: widget.fullscreenAnimation,
            onClose: widget.onClose,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: DayFormContent(
          viewModel: widget.viewModel,
          controller: _controller,
          date: widget.date,
          onSave: _goToConfirmation,
        ),
      ),
    );
  }
}

class _DayFormTopBar extends StatelessWidget {
  const _DayFormTopBar({required this.animation, required this.onClose});

  final Animation<double> animation;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
        ),
      ),
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: _TopBarContent(onClose: onClose),
      ),
    );
  }
}

class _TopBarContent extends StatelessWidget {
  const _TopBarContent({required this.onClose});

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
