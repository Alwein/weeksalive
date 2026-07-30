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

  String get localizedLabel {
    final builtInId = resolveBuiltInIntentId(this);
    if (builtInId != null) {
      return localizedLabelForBuiltInIntentId(builtInId)!;
    }
    return label;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeeklyIntent && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const intentBePresentId = 'intent_be_present';
const intentExploreId = 'intent_explore';
const intentConnectId = 'intent_connect';
const intentRestId = 'intent_rest';
const intentGiveId = 'intent_give';
const intentLearnId = 'intent_learn';
const intentCreateId = 'intent_create';
const intentTakeCareId = 'intent_take_care';
const intentObserveId = 'intent_observe';

const kBuiltInWeeklyIntentIds = {
  intentBePresentId,
  intentExploreId,
  intentConnectId,
  intentRestId,
  intentGiveId,
  intentLearnId,
  intentCreateId,
  intentTakeCareId,
  intentObserveId,
};

const _legacyBuiltInLabelToId = {
  'Be Present': intentBePresentId,
  'Être présent': intentBePresentId,
  intentBePresentId: intentBePresentId,
  'Explore': intentExploreId,
  'Explorer': intentExploreId,
  intentExploreId: intentExploreId,
  'Connect': intentConnectId,
  'Relier': intentConnectId,
  intentConnectId: intentConnectId,
  'Rest': intentRestId,
  'Se reposer': intentRestId,
  intentRestId: intentRestId,
  'Give': intentGiveId,
  'Donner': intentGiveId,
  intentGiveId: intentGiveId,
  'Learn': intentLearnId,
  'Apprendre': intentLearnId,
  intentLearnId: intentLearnId,
  'Create': intentCreateId,
  'Créer': intentCreateId,
  intentCreateId: intentCreateId,
  'Take Care': intentTakeCareId,
  'Prendre soin': intentTakeCareId,
  intentTakeCareId: intentTakeCareId,
  'Observe': intentObserveId,
  'Observer': intentObserveId,
  intentObserveId: intentObserveId,
};

String? resolveBuiltInIntentId(WeeklyIntent intent) {
  if (kBuiltInWeeklyIntentIds.contains(intent.id)) return intent.id;
  return _legacyBuiltInLabelToId[intent.label];
}

String? localizedLabelForBuiltInIntentId(String id) {
  return switch (id) {
    intentBePresentId => Strings.intentBePresent,
    intentExploreId => Strings.intentExplore,
    intentConnectId => Strings.intentConnect,
    intentRestId => Strings.intentRest,
    intentGiveId => Strings.intentGive,
    intentLearnId => Strings.intentLearn,
    intentCreateId => Strings.intentCreate,
    intentTakeCareId => Strings.intentTakeCare,
    intentObserveId => Strings.intentObserve,
    _ => null,
  };
}

WeeklyIntent normalizeWeeklyIntent(WeeklyIntent intent) {
  final builtInId = resolveBuiltInIntentId(intent);
  if (builtInId == null) return intent;

  return WeeklyIntent(
    id: builtInId,
    label: localizedLabelForBuiltInIntentId(builtInId)!,
    lastSelectedAt: intent.lastSelectedAt,
  );
}

List<WeeklyIntent> normalizeWeeklyIntents(List<WeeklyIntent> intents) {
  return intents.map(normalizeWeeklyIntent).toList();
}

List<String> migrateWeeklyIntentSelectionIds(
  List<String> selectedIds,
  List<WeeklyIntent> intentsBefore,
) {
  final idByPreviousId = <String, String>{};
  for (final intent in intentsBefore) {
    final builtInId = resolveBuiltInIntentId(intent);
    if (builtInId != null) {
      idByPreviousId[intent.id] = builtInId;
    }
  }

  return [
    for (final selectedId in selectedIds)
      if (idByPreviousId.containsKey(selectedId)) idByPreviousId[selectedId]! else selectedId,
  ];
}

List<WeeklyIntent> defaultWeeklyIntents() => normalizeWeeklyIntents([
  WeeklyIntent(id: intentBePresentId, label: Strings.intentBePresent),
  WeeklyIntent(id: intentExploreId, label: Strings.intentExplore),
  WeeklyIntent(id: intentConnectId, label: Strings.intentConnect),
  WeeklyIntent(id: intentRestId, label: Strings.intentRest),
  WeeklyIntent(id: intentGiveId, label: Strings.intentGive),
  WeeklyIntent(id: intentLearnId, label: Strings.intentLearn),
  WeeklyIntent(id: intentCreateId, label: Strings.intentCreate),
  WeeklyIntent(id: intentTakeCareId, label: Strings.intentTakeCare),
  WeeklyIntent(id: intentObserveId, label: Strings.intentObserve),
]);

/// Backward-compatible alias for tests and legacy references.
List<WeeklyIntent> get kDefaultWeeklyIntents => defaultWeeklyIntents();
