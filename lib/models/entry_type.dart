enum EntryType {
  score,
  highFinish,
  shortLeg;

  String format(int value) {
    switch (this) {
      case EntryType.score:
        return '$value';

      case EntryType.highFinish:
        return 'High Finish: $value';

      case EntryType.shortLeg:
        return 'Short Leg: $value darts';
    }
  }
}