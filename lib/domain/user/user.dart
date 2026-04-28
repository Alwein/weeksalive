import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum Gender {
  male,
  female,
  other,
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required int lifespan,
    required TimeOfDay notificationTime,
    required DateTime createdAt,
  }) = _User;
}

extension UserExtension on User {
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'gender': gender.name,
    'lifespan': lifespan,
    'notificationTime': {
      'hour': notificationTime.hour,
      'minute': notificationTime.minute,
    },
    'createdAt': createdAt.toIso8601String(),
  };

  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    gender: Gender.values.byName(json['gender'] as String),
    lifespan: json['lifespan'] as int,
    notificationTime: TimeOfDay(
      hour: (json['notificationTime'] as Map<String, dynamic>)['hour'] as int,
      minute: (json['notificationTime'] as Map<String, dynamic>)['minute'] as int,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
