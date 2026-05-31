import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/domain/user/user.dart';

class NotificationSlotState {
  final TimeOfDay time;
  final bool enabled;

  const NotificationSlotState({required this.time, required this.enabled});

  NotificationSlotState copyWith({TimeOfDay? time, bool? enabled}) {
    return NotificationSlotState(
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
    );
  }
}

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
  );

  NotificationSlotState _slot1 = const NotificationSlotState(
    time: TimeOfDay(hour: 18, minute: 0),
    enabled: false,
  );
  NotificationSlotState get slot1 => _slot1;

  NotificationSlotState _slot2 = const NotificationSlotState(
    time: TimeOfDay(hour: 21, minute: 0),
    enabled: true,
  );
  NotificationSlotState get slot2 => _slot2;

  List<TimeOfDay> get notificationTimes => [
    if (_slot1.enabled) _slot1.time,
    if (_slot2.enabled) _slot2.time,
  ];

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

  void toggleIntent(String intentId, {int maxSelections = 3}) {
    if (_selectedIntentIds.contains(intentId)) {
      _selectedIntentIds.remove(intentId);
    } else if (_selectedIntentIds.length < maxSelections) {
      _selectedIntentIds.add(intentId);
    }
    notifyListeners();
  }

  void toggleSlot1(bool value) {
    _slot1 = _slot1.copyWith(enabled: value);
    notifyListeners();
  }

  void toggleSlot2(bool value) {
    _slot2 = _slot2.copyWith(enabled: value);
    notifyListeners();
  }

  void setSlot1Time(TimeOfDay time) {
    _slot1 = _slot1.copyWith(time: time, enabled: true);
    notifyListeners();
  }

  void setSlot2Time(TimeOfDay time) {
    _slot2 = _slot2.copyWith(time: time, enabled: true);
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
    final times = notificationTimes;

    if (name == null || name.isEmpty) return null;
    if (dateOfBirth == null) return null;
    if (gender == null) return null;
    if (times.isEmpty) return null;

    return User(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      lifespan: _lifespan,
      notificationTimes: times,
      createdAt: createdAt,
      weekStartDay: _weekStartDay,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
