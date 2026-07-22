import 'dart:convert';

import '../models/new_entry.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';
import 'backup_data.dart';
import 'backup_mapper.dart';

class BackupService {
  const BackupService();

  String exportToJson(BackupData backup) {
    final mapper = BackupMapper();

    return const JsonEncoder.withIndent('  ').convert(backup.toJson(mapper));
  }

  String export({
    required AppSettings settings,
    required List<NewEntry> entries,
    required List<NewFinishEntry> finishes,
  }) {
    final backup = BackupData(
      version: 3,
      settings: settings,
      entries: entries,
      finishes: finishes,
    );

    return exportToJson(backup);
  }

  BackupData importFromJson(String json) {
    final mapper = BackupMapper();

    final map = jsonDecode(json) as Map<String, dynamic>;

    return BackupData.fromJson(map, mapper);
  }
}
