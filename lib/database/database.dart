import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class ScoreEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get score => integer()();

  IntColumn get type => integer().withDefault(
    const Constant(0),
  )();

  DateTimeColumn get timestamp => dateTime()();
}

@DriftDatabase(
  tables: [
    ScoreEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(
              scoreEntries,
              scoreEntries.type,
            );
          }
        },
      );
}



LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(directory.path, 'dart_tracker.sqlite'),
    );

    return NativeDatabase.createInBackground(file);
  });
}