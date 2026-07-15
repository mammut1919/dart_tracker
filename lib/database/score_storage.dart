import 'package:drift/drift.dart';

import 'database.dart';

class ScoreStorage {
  ScoreStorage(this._database);

  final AppDatabase _database;

  Future<List<ScoreEntry>> getAll() {
    return (_database.select(_database.scoreEntries)
          ..orderBy([
            (t) => OrderingTerm.desc(t.timestamp),
          ]))
        .get();
  }

  Future<void> add(int score, DateTime timestamp) async {
    await _database.into(_database.scoreEntries).insert(
          ScoreEntriesCompanion.insert(
            score: score,
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