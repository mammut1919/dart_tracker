import '../models/finish_multiplier.dart';

const finishFields = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  25,
];

String finishButtonLabel(
  int field,
  FinishMultiplier multiplier,
) {
  if (field == 25) {
    return 'Bull';
  }

  return '$field';
}

String finishChartLabel(
  int field,
  FinishMultiplier multiplier,
) {
  if (field == 25 && multiplier == FinishMultiplier.double) {
    return 'Bull';
  }

  return '${multiplier.prefix}$field';
}
