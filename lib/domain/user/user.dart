import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weeksalive/core/texts/strings.dart';

part 'user.freezed.dart';

enum Gender {
  male,
  female,
  other;

  String get titleCase => switch (this) {
    male => Strings.man,
    female => Strings.woman,
    other => Strings.other,
  };
}

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required int lifespan,
    required DateTime createdAt,

    /// ISO weekday (1 = Monday … 7 = Sunday).
    @Default(DateTime.monday) int weekStartDay,
  }) = _User;
}

extension UserExtension on User {
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'gender': gender.name,
    'lifespan': lifespan,
    'createdAt': createdAt.toIso8601String(),
    'weekStartDay': weekStartDay,
  };

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: Gender.values.byName(json['gender'] as String),
      lifespan: json['lifespan'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      weekStartDay: json['weekStartDay'] as int? ?? DateTime.monday,
    );
  }
}

extension UserUtils on User {
  int dayNumber(DateTime date) {
    final dateOfBirth = this.dateOfBirth;
    final targetDay = DateTime(date.year, date.month, date.day);
    final birthDay = DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day);
    final diff = targetDay.difference(birthDay).inDays;
    return diff < 0 ? 1 : diff + 1;
  }
}
