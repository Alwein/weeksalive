import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/domain/user/user.dart';

/// Person properties derived from the user profile.
///
/// The date of birth never leaves the device: only the age band does. The name
/// is never sent at all.
Map<String, Object> profilePersonProperties({
  required User user,
  required int intentsCount,
  required NotificationSlots slots,
}) {
  return {
    'age_band': ageBand(user.dateOfBirth),
    'gender': user.gender.name,
    'lifespan': user.lifespan,
    'week_start_day': user.weekStartDay,
    'intents_count': intentsCount,
    'notification_slots': notificationSlotsCount(slots),
  };
}

int notificationSlotsCount(NotificationSlots slots) {
  var count = 0;
  if (slots.slot1.enabled) count++;
  if (slots.slot2.enabled) count++;
  if (slots.weeklySummary.enabled) count++;
  return count;
}

/// Buckets a date of birth into a coarse age range.
///
/// "Your life in weeks" does not land the same way at 20 and at 55, so age is
/// worth segmenting on — but a precise birth date is personal data we have no
/// reason to store off-device.
String ageBand(DateTime dateOfBirth, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  var age = reference.year - dateOfBirth.year;
  final hadBirthdayThisYear = reference.month > dateOfBirth.month ||
      (reference.month == dateOfBirth.month && reference.day >= dateOfBirth.day);
  if (!hadBirthdayThisYear) age--;

  if (age < 18) return 'under_18';
  if (age < 25) return '18_24';
  if (age < 35) return '25_34';
  if (age < 45) return '35_44';
  if (age < 55) return '45_54';
  if (age < 65) return '55_64';
  return '65_plus';
}
