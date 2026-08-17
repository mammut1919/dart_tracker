import '../models/new_entry.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';

import 'backup_mapper.dart';

class BackupData {
  const BackupData({
    required this.version,
    required this.settings,
    required this.entries,
    required this.finishes,
  });

  final int version;
  final AppSettings settings;
  final List<NewEntry> entries;
  final List<NewFinishEntry> finishes;

  Map<String, dynamic> toJson(BackupMapper mapper) {
    return {
      'version': version,
      'settings': settings.toJson(),
      'entries': entries.map(mapper.entryToJson).toList(),
      'finishes': finishes.map(mapper.finishToJson).toList(),
    };
  }

  factory BackupData.fromJson(
    Map<String, dynamic> json,
    BackupMapper mapper,
  ) {
    final version = json['version'] as int;

    if (version < 1 || version > 3) {
      throw UnsupportedError('Unsupported backup version: $version');
    }

    final entriesJson =
        (json['entries'] as List).cast<Map<String, dynamic>>();

    final finishJson =
        (json['finishes'] as List? ?? []).cast<Map<String, dynamic>>();

    final entries = <NewEntry>[];
    final finishes = finishJson
        .map(mapper.finishFromJson)
        .toList();

    for (final entryJson in entriesJson) {
      final type = entryJson['type'] as String;

      if (type == 'highFinish') {
        final score = (entryJson['value'] ?? entryJson['score']) as int;
        final timestamp =
            DateTime.parse(entryJson['timestamp'] as String);

        final alreadyExists = finishes.any(
          (finish) =>
              finish.timestamp == timestamp &&
              finish.score == score,
        );

        if (!alreadyExists) {
          finishes.add(
            NewFinishEntry(
              field: null,
              multiplier: null,
              timestamp: timestamp,
              score: score,
            ),
          );
        }

        continue;
      }

      entries.add(
        mapper.entryFromJson(entryJson),
      );
    }

    return BackupData(
      version: version,
      settings: AppSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      entries: entries,
      finishes: finishes,
    );
  }
}
