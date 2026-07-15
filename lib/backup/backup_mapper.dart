import '../models/entry_type.dart';
import '../models/new_entry.dart';

class BackupMapper {
  const BackupMapper();

  Map<String, dynamic> entryToJson(
    NewEntry entry,
  ) {
    return {
      'type': entry.type.name,
      'value': entry.value,
      'timestamp': entry.timestamp.toIso8601String(),
    };
  }

  NewEntry entryFromJson(
  Map<String, dynamic> json,
  ) {
    final type = EntryType.values.byName(
      json['type'] as String,
    );

      final value =
      json['value'] ??
      json['score'];

    return NewEntry(
      type: type,
      value: value as int,
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
    );
  }
}