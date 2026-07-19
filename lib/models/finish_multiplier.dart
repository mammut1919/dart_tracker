enum FinishMultiplier { single, double, triple }

extension FinishMultiplierExtension on FinishMultiplier {
  String get label {
    switch (this) {
      case FinishMultiplier.single:
        return 'Single';
      case FinishMultiplier.double:
        return 'Double';
      case FinishMultiplier.triple:
        return 'Triple';
    }
  }

  String get prefix {
    switch (this) {
      case FinishMultiplier.single:
        return 'S';
      case FinishMultiplier.double:
        return 'D';
      case FinishMultiplier.triple:
        return 'T';
    }
  }

  int get factor {
    switch (this) {
      case FinishMultiplier.single:
        return 1;
      case FinishMultiplier.double:
        return 2;
      case FinishMultiplier.triple:
        return 3;
    }
  }
}
