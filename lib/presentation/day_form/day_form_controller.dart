import 'package:flutter/foundation.dart';
import 'package:weeksalive/domain/day/day.dart';

class DayFormController extends ChangeNotifier {
  DayFormController();

  AverageFeeling? _averageFeeling;
  AverageFeeling? get averageFeeling => _averageFeeling;

  MeaningScore? _meaningScore;
  MeaningScore? get meaningScore => _meaningScore;

  bool? _hasNewExperience;
  bool? get hasNewExperience => _hasNewExperience;

  bool get isComplete =>
      _averageFeeling != null && _meaningScore != null && _hasNewExperience != null;

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

  void reset() {
    _averageFeeling = null;
    _meaningScore = null;
    _hasNewExperience = null;
    notifyListeners();
  }
}
