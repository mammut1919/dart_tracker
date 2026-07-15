import 'package:drift/drift.dart';

import 'database.dart';
import '../models/entry_type.dart';
import '../models/new_entry.dart';

class ScoreStorage {
  ScoreStorage(this._database);

  final AppDatabase _database;

  Future<List<NewEntry>> getAll() async {
    final rows = await (_database.select(_database.scoreEntries)
          ..orderBy([
            (t) => OrderingTerm.desc(t.timestamp),
          ]))
        .get();

    return rows
        .map(
          (row) => NewEntry(
            id: row.id,
            type: EntryType.values[row.type],
            value: row.score,
            timestamp: row.timestamp,
          ),
        )
        .toList();
  }

  Future<void> add(
    EntryType type,
    int score,
    DateTime timestamp
  ) async {
    await _database.into(_database.scoreEntries).insert(
          ScoreEntriesCompanion.insert(
            score: score,
            type: Value(type.index),
            timestamp: timestamp,
          ),
        );
  }

  Future<void> delete(int id) async {
    await (_database.delete(_database.scoreEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> clear() async {
    await _database.delete(_database.scoreEntries).go();
  }
}