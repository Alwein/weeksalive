import 'package:uuid/uuid.dart';
import 'package:weeksalive/core/texts/strings.dart';

class WeeklyIntent {
  final String id;
  final String label;
  final DateTime? lastSelectedAt;

  const WeeklyIntent({
    required this.id,
    required this.label,
    this.lastSelectedAt,
  });

  WeeklyIntent copyWith({
    String? id,
    String? label,
    DateTime? lastSelectedAt,
    bool clearLastSelectedAt = false,
  }) {
    return WeeklyIntent(
      id: id ?? this.id,
      label: label ?? this.label,
      lastSelectedAt: clearLastSelectedAt ? null : (lastSelectedAt ?? this.lastSelectedAt),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'lastSelectedAt': lastSelectedAt?.toIso8601String(),
  };

  static WeeklyIntent fromJson(Map<String, dynamic> json) => WeeklyIntent(
    id: json['id'] as String,
    label: json['label'] as String,
    lastSelectedAt: json['lastSelectedAt'] != null ? DateTime.parse(json['lastSelectedAt'] as String) : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeeklyIntent && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const _uuid = Uuid();

List<WeeklyIntent> kDefaultWeeklyIntents = [
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentBePresent),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentExplore),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentConnect),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentRest),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentGive),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentLearn),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentCreate),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentTakeCare),
  WeeklyIntent(id: _uuid.v4(), label: Strings.intentObserve),
];
