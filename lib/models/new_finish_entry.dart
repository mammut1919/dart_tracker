import 'finish_multiplier.dart';

class NewFinishEntry {
  const NewFinishEntry({
    this.id,
    this.field,
    this.multiplier,
    required this.timestamp,
    this.score,
  })
    : assert(field == null || (field >= 1 && field <= 25)),
      assert(
        (field == null) == (multiplier == null),
        'field and multiplier must be set together',
      ),
      assert(
        score != null || field != null,
        'a finish requires a score or field and multiplier',
      );

  final int? id;
  final int? field;
  final FinishMultiplier? multiplier;
  final DateTime timestamp;
  final int? score;
}
