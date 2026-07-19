import 'entry_type.dart';

class EntryOption {
  const EntryOption({
    required this.label,
    required this.type,
    this.presetValue,
    this.inputLabel,
    this.minValue,
    this.maxValue,
  });

  final String label;
  final EntryType type;
  final int? presetValue;
  final String? inputLabel;
  final int? minValue;
  final int? maxValue;

  bool get requiresInput => presetValue == null;

  String get inputLabelWithRange {
    if (!requiresInput) {
      return label;
    }

    return '$inputLabel ($minValue-$maxValue)';
  }

  bool isValidValue(int value) {
    if (!requiresInput) {
      return true;
    }

    return value >= minValue! && value <= maxValue!;
  }
}
