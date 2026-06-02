import 'package:flutter/foundation.dart';
import 'package:weeksalive/domain/day/day.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

class DayFormController extends ChangeNotifier {
  DayFormController({DayEntry? initialEntry}) {
    if (initialEntry != null) {
      _averageFeeling = initialEntry.averageFeeling;
      _meaningScore = initialEntry.meaningScore;
      _hasNewExperience = initialEntry.hasNewExperience;
      _livingIntentions.addAll(initialEntry.livingIntentionIds);
      _leaveATrace = initialEntry.leaveATrace;
    }
  }

  AverageFeeling? _averageFeeling;
  AverageFeeling? get averageFeeling => _averageFeeling;

  MeaningScore? _meaningScore;
  MeaningScore? get meaningScore => _meaningScore;

  bool? _hasNewExperience;
  bool? get hasNewExperience => _hasNewExperience;

  final Set<String> _livingIntentions = {};
  Set<String> get livingIntentions => Set.unmodifiable(_livingIntentions);

  LeaveATrace _leaveATrace = const LeaveATrace();
  LeaveATrace get leaveATrace => _leaveATrace;

  bool get canSave =>
      _averageFeeling != null ||
      _meaningScore != null ||
      _hasNewExperience != null ||
      _livingIntentions.isNotEmpty ||
      _leaveATrace.isAnswered;

  void setAverageFeeling(AverageFeeling value) {
    if (_averageFeeling == value) return;
    _averageFeeling = value;
    notifyListeners();
  }

  void setMeaningScore(MeaningScore value) {
    if (_meaningScore == value) return;
    _meaningScore = value;
    notifyListeners();
  }

  void setHasNewExperience(bool value) {
    if (_hasNewExperience == value) return;
    _hasNewExperience = value;
    notifyListeners();
  }

  void setLeaveATrace(LeaveATrace value) {
    _leaveATrace = value;
    notifyListeners();
  }

  void toggleLivingIntention(String id) {
    if (_livingIntentions.contains(id)) {
      _livingIntentions.remove(id);
    } else {
      _livingIntentions.add(id);
    }
    notifyListeners();
  }

  DayEntry buildEntry(DateTime date) {
    return DayEntry(
      date: date,
      averageFeeling: _averageFeeling,
      meaningScore: _meaningScore,
      hasNewExperience: _hasNewExperience,
      livingIntentionIds: _livingIntentions.toList(),
      leaveATrace: _leaveATrace,
    );
  }
}
