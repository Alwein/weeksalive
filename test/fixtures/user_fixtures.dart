import 'package:flutter/material.dart';
import 'package:weeksalive/domain/user/user.dart';

User userFixture({
  String id = 'user-id',
  String name = 'Alice',
  DateTime? dateOfBirth,
  Gender gender = Gender.female,
  int lifespan = 90,
  TimeOfDay notificationTime = const TimeOfDay(hour: 9, minute: 0),
  DateTime? createdAt,
}) {
  return User(
    id: id,
    name: name,
    dateOfBirth: dateOfBirth ?? DateTime(1990, 6, 15),
    gender: gender,
    lifespan: lifespan,
    notificationTime: notificationTime,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
  );
}
