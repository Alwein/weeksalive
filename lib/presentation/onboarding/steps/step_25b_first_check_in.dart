import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';
import 'package:weeksalive/presentation/day_form/day_form_view_model.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/redux/analytics/analytics_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// The first real check-in, done before the paywall rather than left for
/// later: users who check in on their first day come back the next day far
/// more often than those who do not.
///
/// The entry is saved as soon as the step is done. Nothing it triggers needs
/// the profile, which only exists once onboarding ends: the iCloud backup
/// waits for a user, and reminders are already scheduled at launch.
class Step25bFirstCheckIn extends OnboardingStep {
  const Step25bFirstCheckIn();

  static const analyticsSource = 'onboarding';

  @override
  String primaryLabel(BuildContext context) => Strings.done;

  @override
  String? secondaryLabel(BuildContext context) => Strings.onboardingFirstCheckInLater;

  @override
  bool canContinue(OnboardingFormController controller) => controller.firstCheckInForm?.canSave ?? false;

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onPrimary => (context, controller) async {
    final entry = controller.recordFirstCheckIn();
    if (entry == null) return;
    StoreProvider.of<AppState>(context, listen: false).dispatch(SaveDayAction(entry));
    await controller.goNext();
  };

  @override
  Future<void> Function(BuildContext, OnboardingFormController)? get onSecondary => (context, controller) async {
    StoreProvider.of<AppState>(context, listen: false).dispatch(const CheckInAbandonedAction());
    await controller.goNext();
  };

  @override
  Widget buildContent(BuildContext context) => const _FirstCheckIn();
}

class _FirstCheckIn extends StatefulWidget {
  const _FirstCheckIn();

  @override
  State<_FirstCheckIn> createState() => _FirstCheckInState();
}

class _FirstCheckInState extends State<_FirstCheckIn> {
  late DateTime _date;
  late DayFormController _form;
  late String _dayCount;
  bool _isYesterday = false;
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;

    final controller = OnboardingScope.read(context);
    final store = StoreProvider.of<AppState>(context, listen: false);
    final now = DateTime.now();

    _date = controller.firstCheckInDay(now);
    _isYesterday = _date != normalizeDay(now);
    _form = controller.openFirstCheckIn(
      _date,
      existingEntry: store.state.dayState.entryFor(_date),
    );
    // The profile is only saved once onboarding ends, so the day number comes
    // from the answers given so far.
    _dayCount = controller.buildUser(id: '', createdAt: now)?.dayNumber(_date).toString() ?? '-';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      store.dispatch(
        CheckInStartedAction(
          source: Step25bFirstCheckIn.analyticsSource,
          dayOffset: _isYesterday ? 1 : 0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Margins.spacingS),
                Texts.onboardingXlBold(Strings.onboardingFirstCheckInTitle),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryRegularSoft(
                  context,
                  _isYesterday
                      ? Strings.onboardingFirstCheckInSubtitleYesterday
                      : Strings.onboardingFirstCheckInSubtitleToday,
                ),
              ],
            ),
          ),
          DayFormContent(
            viewModel: DayFormViewModel(dayCount: _dayCount),
            date: _date,
            controller: _form,
            // Saving goes through the onboarding footer.
            onSave: () {},
            showIntentions: false,
            allowPhotos: false,
            showSaveButton: false,
          ),
        ],
      ),
    );
  }
}
