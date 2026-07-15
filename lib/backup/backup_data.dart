import '../models/new_entry.dart';
import '../settings/app_settings.dart';

import 'backup_mapper.dart';

class BackupData {
  const BackupData({
    required this.version,
    required this.settings,
    required this.entries,
  });

  final int version;
  final AppSettings settings;
  final List<NewEntry> entries;

  Map<String, dynamic> toJson(
    BackupMapper mapper,
  ) {
    return {
      'version': version,
      'settings': settings.toJson(),
      'entries': entries
          .map(mapper.entryToJson)
          .toList(),
    };
  }

  factory BackupData.fromJson(
    Map<String, dynamic> json,
    BackupMapper mapper,
  ) {
    final version = json['version'] as int;

    if (version != 1) {
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
    );
  }
}