import 'finish_multiplier.dart';

class NewFinishEntry {
  const NewFinishEntry({
    this.id,
    required this.field, 
    required this.multiplier,
    required this.timestamp
  })
    : assert((field >= 1 && field <= 20) || field == 50);

  final int? id;
  final int field;
  final FinishMultiplier multiplier;
  final DateTime timestamp;
}
