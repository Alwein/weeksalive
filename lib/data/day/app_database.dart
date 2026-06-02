import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

///
class Days extends Table {
  DateTimeColumn get date => dateTime()();
  TextColumn get averageFeeling => text().nullable()();
  TextColumn get meaningScore => text().nullable()();
  BoolColumn get hasNewExperience => boolean().nullable()();

  TextColumn get livingIntentionIds => text().withDefault(const Constant('[]'))();
  TextColumn get leaveATraceText => text().withDefault(const Constant(''))();

  TextColumn get leaveATraceImagePaths => text().withDefault(const Constant('[]'))();
  IntColumn get sizeLevel => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [Days])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'weeksalive.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
