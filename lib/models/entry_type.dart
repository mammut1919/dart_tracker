import 'package:flutter/material.dart';

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

  IconData get icon {
    switch (this) {
      case EntryType.score:
        return Icons.gps_fixed;

      case EntryType.highFinish:
        return Icons.sports_score;

      case EntryType.shortLeg:
        return Icons.flash_on;
    }
  }
}
