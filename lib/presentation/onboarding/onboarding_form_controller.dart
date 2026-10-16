import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/day_form/day_form_controller.dart';

class OnboardingFormController extends ChangeNotifier {
  OnboardingFormController({required this.totalSteps}) : pageController = PageController();

  final int totalSteps;
  final PageController pageController;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String? _name;
  String? get name => _name;

  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;

  Gender? _gender;
  Gender? get gender => _gender;

  int _lifespan = 85;
  int get lifespan => _lifespan;

  int _weekStartDay = DateTime.monday;
  int get weekStartDay => _weekStartDay;

  final Set<String> _selectedIntentIds = {};
  Set<String> get selectedIntentIds => Set.unmodifiable(_selectedIntentIds);

  bool _gridRevealReady = false;
  bool get gridRevealReady => _gridRevealReady;

  int get currentAge {
    final dob = _dateOfBirth;
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age.clamp(0, 130);
  }

  int get currentAgeInWeeks {
    final dob = _dateOfBirth;
    if (dob == null) return 0;
    final now = DateTime.now();
    final diff = now.difference(dob);
    return diff.inDays ~/ 7;
  }

  int get remainingVisits {
    return (_lifespan - currentAge) * 2;
  }

  int get totalDaysLived {
    final dob = _dateOfBirth;
    if (dob == null) return 0;
    final now = DateTime.now();
    final diff = now.difference(dob);
    return diff.inDays;
  }

  LifeWeekGrid get lifeWeekGrid => LifeWeekGrid.fromProfile(
    dateOfBirth: _dateOfBirth,
    projectedLifespanYears: _lifespan,
    at: DateTime.now(),
    weekStartDay: _weekStartDay,
  );

  NotificationSlots _slots = NotificationSlots.onboardingInitial();
  NotificationSlots get slots => _slots;
  NotificationSlotState get slot1 => _slots.slot1;
  NotificationSlotState get slot2 => _slots.slot2;

  List<TimeOfDay> get notificationTimes => _slots.toNotificationTimes();

  /// The time of day onboarding presents as "your check-in time": the first
  /// enabled reminder, or the slot the user would have picked when none is.
  TimeOfDay get preferredReminderTime {
    final times = notificationTimes;
    if (times.isNotEmpty) return times.first;
    return slot1.enabled ? slot1.time : slot2.time;
  }

  DayFormController? _firstCheckInForm;
  DateTime? _firstCheckInDate;
  DayEntry? _firstCheckIn;

  /// Answers of the check-in done during onboarding, kept while the user moves
  /// back and forth between steps.
  DayFormController? get firstCheckInForm => _firstCheckInForm;
  DateTime? get firstCheckInDate => _firstCheckInDate;

  /// The check-in recorded during onboarding, or null when the user went past
  /// the step without one.
  DayEntry? get firstCheckIn => _firstCheckIn;

  /// Day the onboarding check-in is about. Before the user's reminder time the
  /// day is not over: they look back on yesterday, and tonight's reminder still
  /// comes for today. From the reminder time on, it is today.
  DateTime firstCheckInDay(DateTime now) {
    final today = normalizeDay(now);
    final reminder = preferredReminderTime;
    final minutesNow = now.hour * 60 + now.minute;
    final minutesReminder = reminder.hour * 60 + reminder.minute;
    if (minutesNow < minutesReminder) {
      return today.subtract(const Duration(days: 1));
    }
    return today;
  }

  /// Opens the onboarding check-in on [date]. Coming back to the step on the
  /// same day keeps the answers; [existingEntry] resumes one saved earlier.
  DayFormController openFirstCheckIn(DateTime date, {DayEntry? existingEntry}) {
    final day = normalizeDay(date);
    final current = _firstCheckInForm;
    if (current != null && _firstCheckInDate == day) return current;

    current
      ?..removeListener(notifyListeners)
      ..dispose();
    _firstCheckInDate = day;
    final form = DayFormController(initialEntry: existingEntry)..addListener(notifyListeners);
    _firstCheckInForm = form;
    return form;
  }

  /// Turns the answers into the entry to save, and remembers it for the steps
  /// that follow.
  DayEntry? recordFirstCheckIn() {
    final form = _firstCheckInForm;
    final date = _firstCheckInDate;
    if (form == null || date == null || !form.canSave) return null;
    _firstCheckIn = form.buildEntry(date);
    notifyListeners();
    return _firstCheckIn;
  }

  void setName(String value) {
    final trimmed = value.trim();
    if (_name == trimmed) return;
    _name = trimmed;
    notifyListeners();
  }

  void setDateOfBirth(DateTime value) {
    if (_dateOfBirth == value) return;
    _dateOfBirth = value;
    notifyListeners();
  }

  void setGender(Gender value) {
    if (_gender == value) return;
    _gender = value;
    notifyListeners();
  }

  void setLifespan(int value) {
    if (_lifespan == value) return;
    _lifespan = value;
    notifyListeners();
  }

  void setWeekStartDay(int day) {
    if (_weekStartDay == day) return;
    _weekStartDay = day;
    notifyListeners();
  }

  void setGridRevealReady(bool value) {
    if (_gridRevealReady == value) return;
    _gridRevealReady = value;
    notifyListeners();
  }

  void toggleIntent(String intentId, {int maxSelections = 3}) {
    if (_selectedIntentIds.contains(intentId)) {
      _selectedIntentIds.remove(intentId);
    } else if (_selectedIntentIds.length < maxSelections) {
      _selectedIntentIds.add(intentId);
    }
    notifyListeners();
  }

  void toggleSlot1(bool value) {
    _slots = _slots.copyWith(slot1: _slots.slot1.copyWith(enabled: value));
    notifyListeners();
  }

  void toggleSlot2(bool value) {
    _slots = _slots.copyWith(slot2: _slots.slot2.copyWith(enabled: value));
    notifyListeners();
  }

  void setSlot1Time(TimeOfDay time) {
    _slots = _slots.copyWith(slot1: _slots.slot1.copyWith(time: time, enabled: true));
    notifyListeners();
  }

  void setSlot2Time(TimeOfDay time) {
    _slots = _slots.copyWith(slot2: _slots.slot2.copyWith(time: time, enabled: true));
    notifyListeners();
  }

  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex >= totalSteps - 1;

  Future<void> goNext() async {
    if (isLast) return;
    await pageController.nextPage(
      duration: AnimationDurations.base,
      curve: Curves.easeInOut,
    );
  }

  Future<void> goPrevious() async {
    if (isFirst) return;
    await pageController.previousPage(
      duration: AnimationDurations.base,
      curve: Curves.easeInOut,
    );
  }

  Future<void> jumpTo(int index) async {
    if (index < 0 || index >= totalSteps) return;
    await pageController.animateToPage(
      index,
      duration: AnimationDurations.base,
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  User? buildUser({required String id, required DateTime createdAt}) {
    final name = _name;
    final dateOfBirth = _dateOfBirth;
    final gender = _gender;

    if (name == null || name.isEmpty) return null;
    if (dateOfBirth == null) return null;
    if (gender == null) return null;

    return User(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      lifespan: _lifespan,
      createdAt: createdAt,
      weekStartDay: _weekStartDay,
    );
  }

  @override
  void dispose() {
    _firstCheckInForm
      ?..removeListener(notifyListeners)
      ..dispose();
    pageController.dispose();
    super.dispose();
  }
}
