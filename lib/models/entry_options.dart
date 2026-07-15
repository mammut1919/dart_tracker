import 'entry_option.dart';
import 'entry_type.dart';

const availableEntryOptions = [
  EntryOption(
    label: '180',
    type: EntryType.score,
    presetValue: 180,
  ),
  EntryOption(
    label: '171',
    type: EntryType.score,
    presetValue: 171,
  ),
  EntryOption(
    label: '162',
    type: EntryType.score,
    presetValue: 162,
  ),
  EntryOption(
    label: 'High Finish',
    type: EntryType.highFinish,
    inputLabel: 'Wert',
    minValue: 100,
    maxValue: 180,
  ),
  EntryOption(
    label: 'Short Leg',
    type: EntryType.shortLeg,
    inputLabel: 'Darts',
    minValue: 9,
    maxValue: 24,
  ),
];