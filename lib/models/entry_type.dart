enum EntryType {
  score,
  highFinish,
  shortLeg;

  String format(int value) {
    switch (this) {
      case EntryType.score:
        return '$value';

      case EntryType.highFinish:
        return 'HF $value';

      case EntryType.shortLeg:
        return 'SL $value';
    }
  }
}