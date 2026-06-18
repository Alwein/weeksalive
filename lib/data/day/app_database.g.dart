// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DaysTable extends Days with TableInfo<$DaysTable, Day> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageFeelingMeta = const VerificationMeta(
    'averageFeeling',
  );
  @override
  late final GeneratedColumn<String> averageFeeling = GeneratedColumn<String>(
    'average_feeling',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningScoreMeta = const VerificationMeta(
    'meaningScore',
  );
  @override
  late final GeneratedColumn<String> meaningScore = GeneratedColumn<String>(
    'meaning_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasNewExperienceMeta = const VerificationMeta(
    'hasNewExperience',
  );
  @override
  late final GeneratedColumn<bool> hasNewExperience = GeneratedColumn<bool>(
    'has_new_experience',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_new_experience" IN (0, 1))',
    ),
  );
  static const VerificationMeta _livingIntentionIdsMeta =
      const VerificationMeta('livingIntentionIds');
  @override
  late final GeneratedColumn<String> livingIntentionIds =
      GeneratedColumn<String>(
        'living_intention_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _leaveATraceTextMeta = const VerificationMeta(
    'leaveATraceText',
  );
  @override
  late final GeneratedColumn<String> leaveATraceText = GeneratedColumn<String>(
    'leave_a_trace_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _leaveATraceImagePathsMeta =
      const VerificationMeta('leaveATraceImagePaths');
  @override
  late final GeneratedColumn<String> leaveATraceImagePaths =
      GeneratedColumn<String>(
        'leave_a_trace_image_paths',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _sizeLevelMeta = const VerificationMeta(
    'sizeLevel',
  );
  @override
  late final GeneratedColumn<int> sizeLevel = GeneratedColumn<int>(
    'size_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    averageFeeling,
    meaningScore,
    hasNewExperience,
    livingIntentionIds,
    leaveATraceText,
    leaveATraceImagePaths,
    sizeLevel,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'days';
  @override
  VerificationContext validateIntegrity(
    Insertable<Day> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('average_feeling')) {
      context.handle(
        _averageFeelingMeta,
        averageFeeling.isAcceptableOrUnknown(
          data['average_feeling']!,
          _averageFeelingMeta,
        ),
      );
    }
    if (data.containsKey('meaning_score')) {
      context.handle(
        _meaningScoreMeta,
        meaningScore.isAcceptableOrUnknown(
          data['meaning_score']!,
          _meaningScoreMeta,
        ),
      );
    }
    if (data.containsKey('has_new_experience')) {
      context.handle(
        _hasNewExperienceMeta,
        hasNewExperience.isAcceptableOrUnknown(
          data['has_new_experience']!,
          _hasNewExperienceMeta,
        ),
      );
    }
    if (data.containsKey('living_intention_ids')) {
      context.handle(
        _livingIntentionIdsMeta,
        livingIntentionIds.isAcceptableOrUnknown(
          data['living_intention_ids']!,
          _livingIntentionIdsMeta,
        ),
      );
    }
    if (data.containsKey('leave_a_trace_text')) {
      context.handle(
        _leaveATraceTextMeta,
        leaveATraceText.isAcceptableOrUnknown(
          data['leave_a_trace_text']!,
          _leaveATraceTextMeta,
        ),
      );
    }
    if (data.containsKey('leave_a_trace_image_paths')) {
      context.handle(
        _leaveATraceImagePathsMeta,
        leaveATraceImagePaths.isAcceptableOrUnknown(
          data['leave_a_trace_image_paths']!,
          _leaveATraceImagePathsMeta,
        ),
      );
    }
    if (data.containsKey('size_level')) {
      context.handle(
        _sizeLevelMeta,
        sizeLevel.isAcceptableOrUnknown(data['size_level']!, _sizeLevelMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  Day map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Day(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      averageFeeling: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}average_feeling'],
      ),
      meaningScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_score'],
      ),
      hasNewExperience: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_new_experience'],
      ),
      livingIntentionIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}living_intention_ids'],
      )!,
      leaveATraceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_a_trace_text'],
      )!,
      leaveATraceImagePaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_a_trace_image_paths'],
      )!,
      sizeLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_level'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $DaysTable createAlias(String alias) {
    return $DaysTable(attachedDatabase, alias);
  }
}

class Day extends DataClass implements Insertable<Day> {
  final DateTime date;
  final String? averageFeeling;
  final String? meaningScore;
  final bool? hasNewExperience;
  final String livingIntentionIds;
  final String leaveATraceText;
  final String leaveATraceImagePaths;
  final int sizeLevel;
  final DateTime savedAt;
  const Day({
    required this.date,
    this.averageFeeling,
    this.meaningScore,
    this.hasNewExperience,
    required this.livingIntentionIds,
    required this.leaveATraceText,
    required this.leaveATraceImagePaths,
    required this.sizeLevel,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || averageFeeling != null) {
      map['average_feeling'] = Variable<String>(averageFeeling);
    }
    if (!nullToAbsent || meaningScore != null) {
      map['meaning_score'] = Variable<String>(meaningScore);
    }
    if (!nullToAbsent || hasNewExperience != null) {
      map['has_new_experience'] = Variable<bool>(hasNewExperience);
    }
    map['living_intention_ids'] = Variable<String>(livingIntentionIds);
    map['leave_a_trace_text'] = Variable<String>(leaveATraceText);
    map['leave_a_trace_image_paths'] = Variable<String>(leaveATraceImagePaths);
    map['size_level'] = Variable<int>(sizeLevel);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  DaysCompanion toCompanion(bool nullToAbsent) {
    return DaysCompanion(
      date: Value(date),
      averageFeeling: averageFeeling == null && nullToAbsent
          ? const Value.absent()
          : Value(averageFeeling),
      meaningScore: meaningScore == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningScore),
      hasNewExperience: hasNewExperience == null && nullToAbsent
          ? const Value.absent()
          : Value(hasNewExperience),
      livingIntentionIds: Value(livingIntentionIds),
      leaveATraceText: Value(leaveATraceText),
      leaveATraceImagePaths: Value(leaveATraceImagePaths),
      sizeLevel: Value(sizeLevel),
      savedAt: Value(savedAt),
    );
  }

  factory Day.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Day(
      date: serializer.fromJson<DateTime>(json['date']),
      averageFeeling: serializer.fromJson<String?>(json['averageFeeling']),
      meaningScore: serializer.fromJson<String?>(json['meaningScore']),
      hasNewExperience: serializer.fromJson<bool?>(json['hasNewExperience']),
      livingIntentionIds: serializer.fromJson<String>(
        json['livingIntentionIds'],
      ),
      leaveATraceText: serializer.fromJson<String>(json['leaveATraceText']),
      leaveATraceImagePaths: serializer.fromJson<String>(
        json['leaveATraceImagePaths'],
      ),
      sizeLevel: serializer.fromJson<int>(json['sizeLevel']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'averageFeeling': serializer.toJson<String?>(averageFeeling),
      'meaningScore': serializer.toJson<String?>(meaningScore),
      'hasNewExperience': serializer.toJson<bool?>(hasNewExperience),
      'livingIntentionIds': serializer.toJson<String>(livingIntentionIds),
      'leaveATraceText': serializer.toJson<String>(leaveATraceText),
      'leaveATraceImagePaths': serializer.toJson<String>(leaveATraceImagePaths),
      'sizeLevel': serializer.toJson<int>(sizeLevel),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  Day copyWith({
    DateTime? date,
    Value<String?> averageFeeling = const Value.absent(),
    Value<String?> meaningScore = const Value.absent(),
    Value<bool?> hasNewExperience = const Value.absent(),
    String? livingIntentionIds,
    String? leaveATraceText,
    String? leaveATraceImagePaths,
    int? sizeLevel,
    DateTime? savedAt,
  }) => Day(
    date: date ?? this.date,
    averageFeeling: averageFeeling.present
        ? averageFeeling.value
        : this.averageFeeling,
    meaningScore: meaningScore.present ? meaningScore.value : this.meaningScore,
    hasNewExperience: hasNewExperience.present
        ? hasNewExperience.value
        : this.hasNewExperience,
    livingIntentionIds: livingIntentionIds ?? this.livingIntentionIds,
    leaveATraceText: leaveATraceText ?? this.leaveATraceText,
    leaveATraceImagePaths: leaveATraceImagePaths ?? this.leaveATraceImagePaths,
    sizeLevel: sizeLevel ?? this.sizeLevel,
    savedAt: savedAt ?? this.savedAt,
  );
  Day copyWithCompanion(DaysCompanion data) {
    return Day(
      date: data.date.present ? data.date.value : this.date,
      averageFeeling: data.averageFeeling.present
          ? data.averageFeeling.value
          : this.averageFeeling,
      meaningScore: data.meaningScore.present
          ? data.meaningScore.value
          : this.meaningScore,
      hasNewExperience: data.hasNewExperience.present
          ? data.hasNewExperience.value
          : this.hasNewExperience,
      livingIntentionIds: data.livingIntentionIds.present
          ? data.livingIntentionIds.value
          : this.livingIntentionIds,
      leaveATraceText: data.leaveATraceText.present
          ? data.leaveATraceText.value
          : this.leaveATraceText,
      leaveATraceImagePaths: data.leaveATraceImagePaths.present
          ? data.leaveATraceImagePaths.value
          : this.leaveATraceImagePaths,
      sizeLevel: data.sizeLevel.present ? data.sizeLevel.value : this.sizeLevel,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Day(')
          ..write('date: $date, ')
          ..write('averageFeeling: $averageFeeling, ')
          ..write('meaningScore: $meaningScore, ')
          ..write('hasNewExperience: $hasNewExperience, ')
          ..write('livingIntentionIds: $livingIntentionIds, ')
          ..write('leaveATraceText: $leaveATraceText, ')
          ..write('leaveATraceImagePaths: $leaveATraceImagePaths, ')
          ..write('sizeLevel: $sizeLevel, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    averageFeeling,
    meaningScore,
    hasNewExperience,
    livingIntentionIds,
    leaveATraceText,
    leaveATraceImagePaths,
    sizeLevel,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Day &&
          other.date == this.date &&
          other.averageFeeling == this.averageFeeling &&
          other.meaningScore == this.meaningScore &&
          other.hasNewExperience == this.hasNewExperience &&
          other.livingIntentionIds == this.livingIntentionIds &&
          other.leaveATraceText == this.leaveATraceText &&
          other.leaveATraceImagePaths == this.leaveATraceImagePaths &&
          other.sizeLevel == this.sizeLevel &&
          other.savedAt == this.savedAt);
}

class DaysCompanion extends UpdateCompanion<Day> {
  final Value<DateTime> date;
  final Value<String?> averageFeeling;
  final Value<String?> meaningScore;
  final Value<bool?> hasNewExperience;
  final Value<String> livingIntentionIds;
  final Value<String> leaveATraceText;
  final Value<String> leaveATraceImagePaths;
  final Value<int> sizeLevel;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const DaysCompanion({
    this.date = const Value.absent(),
    this.averageFeeling = const Value.absent(),
    this.meaningScore = const Value.absent(),
    this.hasNewExperience = const Value.absent(),
    this.livingIntentionIds = const Value.absent(),
    this.leaveATraceText = const Value.absent(),
    this.leaveATraceImagePaths = const Value.absent(),
    this.sizeLevel = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DaysCompanion.insert({
    required DateTime date,
    this.averageFeeling = const Value.absent(),
    this.meaningScore = const Value.absent(),
    this.hasNewExperience = const Value.absent(),
    this.livingIntentionIds = const Value.absent(),
    this.leaveATraceText = const Value.absent(),
    this.leaveATraceImagePaths = const Value.absent(),
    this.sizeLevel = const Value.absent(),
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       savedAt = Value(savedAt);
  static Insertable<Day> custom({
    Expression<DateTime>? date,
    Expression<String>? averageFeeling,
    Expression<String>? meaningScore,
    Expression<bool>? hasNewExperience,
    Expression<String>? livingIntentionIds,
    Expression<String>? leaveATraceText,
    Expression<String>? leaveATraceImagePaths,
    Expression<int>? sizeLevel,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (averageFeeling != null) 'average_feeling': averageFeeling,
      if (meaningScore != null) 'meaning_score': meaningScore,
      if (hasNewExperience != null) 'has_new_experience': hasNewExperience,
      if (livingIntentionIds != null)
        'living_intention_ids': livingIntentionIds,
      if (leaveATraceText != null) 'leave_a_trace_text': leaveATraceText,
      if (leaveATraceImagePaths != null)
        'leave_a_trace_image_paths': leaveATraceImagePaths,
      if (sizeLevel != null) 'size_level': sizeLevel,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DaysCompanion copyWith({
    Value<DateTime>? date,
    Value<String?>? averageFeeling,
    Value<String?>? meaningScore,
    Value<bool?>? hasNewExperience,
    Value<String>? livingIntentionIds,
    Value<String>? leaveATraceText,
    Value<String>? leaveATraceImagePaths,
    Value<int>? sizeLevel,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return DaysCompanion(
      date: date ?? this.date,
      averageFeeling: averageFeeling ?? this.averageFeeling,
      meaningScore: meaningScore ?? this.meaningScore,
      hasNewExperience: hasNewExperience ?? this.hasNewExperience,
      livingIntentionIds: livingIntentionIds ?? this.livingIntentionIds,
      leaveATraceText: leaveATraceText ?? this.leaveATraceText,
      leaveATraceImagePaths:
          leaveATraceImagePaths ?? this.leaveATraceImagePaths,
      sizeLevel: sizeLevel ?? this.sizeLevel,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (averageFeeling.present) {
      map['average_feeling'] = Variable<String>(averageFeeling.value);
    }
    if (meaningScore.present) {
      map['meaning_score'] = Variable<String>(meaningScore.value);
    }
    if (hasNewExperience.present) {
      map['has_new_experience'] = Variable<bool>(hasNewExperience.value);
    }
    if (livingIntentionIds.present) {
      map['living_intention_ids'] = Variable<String>(livingIntentionIds.value);
    }
    if (leaveATraceText.present) {
      map['leave_a_trace_text'] = Variable<String>(leaveATraceText.value);
    }
    if (leaveATraceImagePaths.present) {
      map['leave_a_trace_image_paths'] = Variable<String>(
        leaveATraceImagePaths.value,
      );
    }
    if (sizeLevel.present) {
      map['size_level'] = Variable<int>(sizeLevel.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaysCompanion(')
          ..write('date: $date, ')
          ..write('averageFeeling: $averageFeeling, ')
          ..write('meaningScore: $meaningScore, ')
          ..write('hasNewExperience: $hasNewExperience, ')
          ..write('livingIntentionIds: $livingIntentionIds, ')
          ..write('leaveATraceText: $leaveATraceText, ')
          ..write('leaveATraceImagePaths: $leaveATraceImagePaths, ')
          ..write('sizeLevel: $sizeLevel, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DaysTable days = $DaysTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [days];
}

typedef $$DaysTableCreateCompanionBuilder =
    DaysCompanion Function({
      required DateTime date,
      Value<String?> averageFeeling,
      Value<String?> meaningScore,
      Value<bool?> hasNewExperience,
      Value<String> livingIntentionIds,
      Value<String> leaveATraceText,
      Value<String> leaveATraceImagePaths,
      Value<int> sizeLevel,
      required DateTime savedAt,
      Value<int> rowid,
    });
typedef $$DaysTableUpdateCompanionBuilder =
    DaysCompanion Function({
      Value<DateTime> date,
      Value<String?> averageFeeling,
      Value<String?> meaningScore,
      Value<bool?> hasNewExperience,
      Value<String> livingIntentionIds,
      Value<String> leaveATraceText,
      Value<String> leaveATraceImagePaths,
      Value<int> sizeLevel,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$DaysTableFilterComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get averageFeeling => $composableBuilder(
    column: $table.averageFeeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningScore => $composableBuilder(
    column: $table.meaningScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasNewExperience => $composableBuilder(
    column: $table.hasNewExperience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get livingIntentionIds => $composableBuilder(
    column: $table.livingIntentionIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveATraceText => $composableBuilder(
    column: $table.leaveATraceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveATraceImagePaths => $composableBuilder(
    column: $table.leaveATraceImagePaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeLevel => $composableBuilder(
    column: $table.sizeLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DaysTableOrderingComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get averageFeeling => $composableBuilder(
    column: $table.averageFeeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningScore => $composableBuilder(
    column: $table.meaningScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasNewExperience => $composableBuilder(
    column: $table.hasNewExperience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get livingIntentionIds => $composableBuilder(
    column: $table.livingIntentionIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveATraceText => $composableBuilder(
    column: $table.leaveATraceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveATraceImagePaths => $composableBuilder(
    column: $table.leaveATraceImagePaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeLevel => $composableBuilder(
    column: $table.sizeLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get averageFeeling => $composableBuilder(
    column: $table.averageFeeling,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningScore => $composableBuilder(
    column: $table.meaningScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasNewExperience => $composableBuilder(
    column: $table.hasNewExperience,
    builder: (column) => column,
  );

  GeneratedColumn<String> get livingIntentionIds => $composableBuilder(
    column: $table.livingIntentionIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaveATraceText => $composableBuilder(
    column: $table.leaveATraceText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaveATraceImagePaths => $composableBuilder(
    column: $table.leaveATraceImagePaths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sizeLevel =>
      $composableBuilder(column: $table.sizeLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$DaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DaysTable,
          Day,
          $$DaysTableFilterComposer,
          $$DaysTableOrderingComposer,
          $$DaysTableAnnotationComposer,
          $$DaysTableCreateCompanionBuilder,
          $$DaysTableUpdateCompanionBuilder,
          (Day, BaseReferences<_$AppDatabase, $DaysTable, Day>),
          Day,
          PrefetchHooks Function()
        > {
  $$DaysTableTableManager(_$AppDatabase db, $DaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<String?> averageFeeling = const Value.absent(),
                Value<String?> meaningScore = const Value.absent(),
                Value<bool?> hasNewExperience = const Value.absent(),
                Value<String> livingIntentionIds = const Value.absent(),
                Value<String> leaveATraceText = const Value.absent(),
                Value<String> leaveATraceImagePaths = const Value.absent(),
                Value<int> sizeLevel = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion(
                date: date,
                averageFeeling: averageFeeling,
                meaningScore: meaningScore,
                hasNewExperience: hasNewExperience,
                livingIntentionIds: livingIntentionIds,
                leaveATraceText: leaveATraceText,
                leaveATraceImagePaths: leaveATraceImagePaths,
                sizeLevel: sizeLevel,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<String?> averageFeeling = const Value.absent(),
                Value<String?> meaningScore = const Value.absent(),
                Value<bool?> hasNewExperience = const Value.absent(),
                Value<String> livingIntentionIds = const Value.absent(),
                Value<String> leaveATraceText = const Value.absent(),
                Value<String> leaveATraceImagePaths = const Value.absent(),
                Value<int> sizeLevel = const Value.absent(),
                required DateTime savedAt,
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion.insert(
                date: date,
                averageFeeling: averageFeeling,
                meaningScore: meaningScore,
                hasNewExperience: hasNewExperience,
                livingIntentionIds: livingIntentionIds,
                leaveATraceText: leaveATraceText,
                leaveATraceImagePaths: leaveATraceImagePaths,
                sizeLevel: sizeLevel,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DaysTable,
      Day,
      $$DaysTableFilterComposer,
      $$DaysTableOrderingComposer,
      $$DaysTableAnnotationComposer,
      $$DaysTableCreateCompanionBuilder,
      $$DaysTableUpdateCompanionBuilder,
      (Day, BaseReferences<_$AppDatabase, $DaysTable, Day>),
      Day,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DaysTableTableManager get days => $$DaysTableTableManager(_db, _db.days);
}
