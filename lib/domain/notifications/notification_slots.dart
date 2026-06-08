import 'package:flutter/material.dart';

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

/// Two configurable daily notification slots.
///
/// The [User] model only stores enabled times as a flat list. This class
/// provides the bidirectional mapping between that list and two UI slots.
class NotificationSlots {
  static const defaultSlot1Time = TimeOfDay(hour: 18, minute: 0);
  static const defaultSlot2Time = TimeOfDay(hour: 21, minute: 0);

  final NotificationSlotState slot1;
  final NotificationSlotState slot2;

  const NotificationSlots({required this.slot1, required this.slot2});

  factory NotificationSlots.defaults() => const NotificationSlots(
    slot1: NotificationSlotState(time: defaultSlot1Time, enabled: false),
    slot2: NotificationSlotState(time: defaultSlot2Time, enabled: false),
  );

  factory NotificationSlots.onboardingInitial() => const NotificationSlots(
    slot1: NotificationSlotState(time: defaultSlot1Time, enabled: false),
    slot2: NotificationSlotState(time: defaultSlot2Time, enabled: true),
  );

  factory NotificationSlots.fromNotificationTimes(List<TimeOfDay> times) {
    final defaults = NotificationSlots.defaults();
    if (times.isEmpty) return defaults;

    final remaining = List<TimeOfDay>.from(times);

    var slot1 = defaults.slot1.copyWith(
      enabled: _removeIfPresent(remaining, defaultSlot1Time),
    );
    var slot2 = defaults.slot2.copyWith(
      enabled: _removeIfPresent(remaining, defaultSlot2Time),
    );

    if (remaining.length == 1 && !slot1.enabled && !slot2.enabled) {
      final time = remaining.single;
      if (_matches(time, defaultSlot1Time)) {
        slot1 = slot1.copyWith(enabled: true);
      } else {
        slot2 = slot2.copyWith(time: time, enabled: true);
      }
      return NotificationSlots(slot1: slot1, slot2: slot2);
    }

    if (!slot1.enabled && remaining.isNotEmpty) {
      slot1 = slot1.copyWith(time: remaining.removeAt(0), enabled: true);
    }
    if (!slot2.enabled && remaining.isNotEmpty) {
      slot2 = slot2.copyWith(time: remaining.removeAt(0), enabled: true);
    }

    return NotificationSlots(slot1: slot1, slot2: slot2);
  }

  List<TimeOfDay> toNotificationTimes() => [
    if (slot1.enabled) slot1.time,
    if (slot2.enabled) slot2.time,
  ];

  NotificationSlots copyWith({
    NotificationSlotState? slot1,
    NotificationSlotState? slot2,
  }) {
    return NotificationSlots(
      slot1: slot1 ?? this.slot1,
      slot2: slot2 ?? this.slot2,
    );
  }

  static bool _matches(TimeOfDay a, TimeOfDay b) => a.hour == b.hour && a.minute == b.minute;

  static bool _removeIfPresent(List<TimeOfDay> times, TimeOfDay target) {
    final index = times.indexWhere((time) => _matches(time, target));
    if (index == -1) return false;
    times.removeAt(index);
    return true;
  }
}
