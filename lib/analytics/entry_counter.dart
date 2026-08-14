import '../models/entry_type.dart';
import '../models/new_entry.dart';

class EntryCounter {
  const EntryCounter();

  int count({
    required List<NewEntry> entries,
    required EntryType type,
    int? value,
    required int shortLegLimit,
    bool onlyValidShortLegs = false,
  }) {
    return entries.where((entry) {
      if (entry.type != type) {
        return false;
      }

      if (value != null && entry.value != value) {
        return false;
      }

      if (onlyValidShortLegs &&
          type == EntryType.shortLeg &&
          entry.value > shortLegLimit) {
        return false;
      }

      return true;
    }).length;
  }
}