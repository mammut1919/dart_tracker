import 'entry_type.dart';

class NewEntry {
  const NewEntry({
    this.id,
    required this.type,
    required this.value,
    required this.timestamp,
  });

  final int? id;
  final EntryType type;
  final int value;
  final DateTime timestamp;
}
