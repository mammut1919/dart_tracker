import 'entry_option.dart';
import 'entry_type.dart';

const score180Option = EntryOption(
  label: '180',
  type: EntryType.score,
  presetValue: 180,
);

const score171Option = EntryOption(
  label: '171',
  type: EntryType.score,
  presetValue: 171,
);

const score162Option = EntryOption(
  label: '162',
  type: EntryType.score,
  presetValue: 162,
);

const highFinishOption = EntryOption(
  label: 'High Finish',
  type: EntryType.highFinish,
  inputLabel: 'Wert',
  minValue: 100,
  maxValue: 180,
);

const shortLegOption = EntryOption(
  label: 'Short Leg',
  type: EntryType.shortLeg,
  inputLabel: 'Darts',
  minValue: 9,
  maxValue: 24,
);

const availableEntryOptions = [
  score180Option,
  score171Option,
  score162Option,
  highFinishOption,
  shortLegOption,
];