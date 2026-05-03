import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/domain/user/user.dart';

enum NotificationSlot { morning, afternoon, evening, custom }

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

  /// Weeks in the onboarding grid from birth to projected end of life, and weeks lived so far.
  LifeWeekGrid get lifeWeekGrid => LifeWeekGrid.fromProfile(
        dateOfBirth: _dateOfBirth,
        projectedLifespanYears: _lifespan,
        at: DateTime.now(),
      );

  NotificationSlot? _notificationSlot;
  NotificationSlot? get notificationSlot => _notificationSlot;

  TimeOfDay? _customNotificationTime;
  TimeOfDay? get customNotificationTime => _customNotificationTime;

  TimeOfDay? get notificationTime {
    return switch (_notificationSlot) {
      NotificationSlot.morning => const TimeOfDay(hour: 8, minute: 0),
      NotificationSlot.afternoon => const TimeOfDay(hour: 14, minute: 30),
      NotificationSlot.evening => const TimeOfDay(hour: 21, minute: 0),
      NotificationSlot.custom => _customNotificationTime,
      null => null,
    };
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

  void setNotificationSlot(NotificationSlot value) {
    if (_notificationSlot == value) return;
    _notificationSlot = value;
    notifyListeners();
  }

  void setCustomNotificationTime(TimeOfDay value) {
    _customNotificationTime = value;
    _notificationSlot = NotificationSlot.custom;
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
    final notificationTime = this.notificationTime;

    if (name == null || name.isEmpty) return null;
    if (dateOfBirth == null) return null;
    if (gender == null) return null;
    if (notificationTime == null) return null;

    return User(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      lifespan: _lifespan,
      notificationTime: notificationTime,
      createdAt: createdAt,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
