import 'package:flutter/material.dart';
import 'package:weeksalive/domain/user/user.dart';

class EditProfileFormController extends ChangeNotifier {
  EditProfileFormController({
    required this.originalName,
    required this.originalDateOfBirth,
    required this.originalGender,
    required this.originalLifespan,
  }) : _name = originalName,
       _dateOfBirth = originalDateOfBirth,
       _gender = originalGender,
       _lifespan = originalLifespan;

  final String originalName;
  final DateTime originalDateOfBirth;
  final Gender originalGender;
  final int originalLifespan;

  String _name;
  String get name => _name;

  DateTime _dateOfBirth;
  DateTime get dateOfBirth => _dateOfBirth;

  Gender _gender;
  Gender get gender => _gender;

  int _lifespan;
  int get lifespan => _lifespan;

  int get currentAge {
    final now = DateTime.now();
    var age = now.year - _dateOfBirth.year;
    if (now.month < _dateOfBirth.month || (now.month == _dateOfBirth.month && now.day < _dateOfBirth.day)) {
      age--;
    }
    return age.clamp(0, 130);
  }

  bool get isDirty =>
      _name != originalName ||
      _dateOfBirth != originalDateOfBirth ||
      _gender != originalGender ||
      _lifespan != originalLifespan;

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
}
