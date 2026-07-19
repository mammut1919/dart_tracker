import 'package:drift/drift.dart';

import 'database.dart';
import '../models/new_finish_entry.dart';

class FinishStorage {
  FinishStorage(this._database);

  final AppDatabase _database;

  Future<List<NewFinishEntry>> getAll() async {
    final rows = await (_database.select(_database.finishEntries)
          ..orderBy([
            (t) => OrderingTerm.desc(t.timestamp),
          ]))
        .get();

    return rows
        .map(
          (row) => NewFinishEntry(
            id: row.id,
            field: row.field,
            timestamp: row.timestamp,
          ),
        )
        .toList();
  }

  Future<void> add(
    int field,
    DateTime timestamp,
  ) async {
    await _database.into(_database.finishEntries).insert(
          FinishEntriesCompanion.insert(
            field: field,
            timestamp: timestamp,
          ),
        );
  }

  Future<void> delete(int id) async {
    await (_database.delete(_database.finishEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> clear() async {
    await _database.delete(_database.finishEntries).go();
  }
}