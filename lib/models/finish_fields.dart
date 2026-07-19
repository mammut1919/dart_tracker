import '../models/finish_multiplier_selector.dart';

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
  50,
];

String finishButtonLabel(int field) {
  return field == 50 ? 'Bull' : '$field';
}

String finishChartLabel(int field, FinishMultiplier multiplier) {
  if (field == 50) {
    return 'Bull';
  }

  return '${multiplier.prefix}$field';
}