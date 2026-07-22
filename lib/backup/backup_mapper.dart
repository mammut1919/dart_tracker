import '../models/entry_type.dart';
import '../models/finish_multiplier.dart';
import '../models/new_entry.dart';
import '../models/new_finish_entry.dart';

class BackupMapper {
  const BackupMapper();

  Map<String, dynamic> entryToJson(NewEntry entry) {
    return {
      'type': entry.type.name,
      'value': entry.value,
      'timestamp': entry.timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> finishToJson(NewFinishEntry finish) {
    return {
      'field': finish.field,
      'multiplier': finish.multiplier.name,
      'timestamp': finish.timestamp.toIso8601String(),
    };
  }

  NewEntry entryFromJson(Map<String, dynamic> json) {

    final typeName = json['type'] as String;

    final type = switch (typeName) {
      'score_entry' => EntryType.score,
      _ => EntryType.values.byName(typeName),
    };

    final value = json['value'] ?? json['score'];

    return NewEntry(
      type: type,
      value: value as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  NewFinishEntry finishFromJson(Map<String, dynamic> json) {
    return NewFinishEntry(
      field: json['field'] as int,
      multiplier: FinishMultiplier.values.byName(
        json['multiplier'] as String? ?? 'double',
      ),
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
    );
  }
}
