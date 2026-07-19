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
  

  Map<String, dynamic> toJson(
    BackupMapper mapper,
  ) {
    return {
      'version': version,
      'settings': settings.toJson(),
      'entries': entries
        .map(mapper.entryToJson)
        .toList(),
      'finishes': finishes
        .map(mapper.finishToJson)
        .toList(),
    };
  }

  factory BackupData.fromJson(
    Map<String, dynamic> json,
    BackupMapper mapper,
  ) {
    final version = json['version'] as int;

    if (version < 1 || version > 2) {
      throw UnsupportedError(
        'Unsupported backup version: $version',
      );
    }

    return BackupData(
      version: version,
      settings: AppSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      entries: (json['entries'] as List)
        .map(
          (entry) => mapper.entryFromJson(
            entry as Map<String, dynamic>,
          ),
        )
        .toList(),
      finishes: (json['finishes'] as List? ?? [])
        .map(
          (entry) => mapper.finishFromJson(
            entry as Map<String, dynamic>,
          ),
        )
        .toList(),
      );
  }
}