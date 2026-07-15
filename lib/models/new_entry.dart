import 'entry_type.dart';

class NewEntry {
  const NewEntry({
    required this.type,
    required this.value,
    required this.timestamp,
  });

  final EntryType type;
  final int value;
  final DateTime timestamp;
}