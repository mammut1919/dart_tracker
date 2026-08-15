import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class ScoreEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get score => integer()();

  IntColumn get type => integer().withDefault(const Constant(0))();

  DateTimeColumn get timestamp => dateTime()();
}

class FinishEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get field => integer().nullable()();

  TextColumn get multiplier => text().nullable()();

  DateTimeColumn get timestamp => dateTime()();

  IntColumn get score => integer().nullable()();
}

@DriftDatabase(tables: [ScoreEntries, FinishEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(scoreEntries, scoreEntries.type);
      }

      if (from < 3) {
        await m.createTable(finishEntries);
      }

      if (from < 4) {
        await m.addColumn(
          finishEntries,
          finishEntries.multiplier,
        );
      }

      if (from < 5) {
        await m.addColumn(
          finishEntries,
          finishEntries.score,
        );
      }

      if (from < 6) {
        await customStatement(
          'UPDATE finish_entries SET field = 25 WHERE field = 50',
        );
      }

      if (from < 7) {
        await m.alterTable(TableMigration(finishEntries));
      }
    },
  );
}

LazyDatabase _openConnection() {
  
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(p.join(directory.path, 'dart_tracker.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
