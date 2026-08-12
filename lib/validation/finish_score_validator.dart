import '../models/finish_multiplier.dart';

class FinishScoreValidation {
  const FinishScoreValidation({
    required this.isValid,
    this.errorMessage,
  });

  final bool isValid;
  final String? errorMessage;
}

class FinishScoreValidator {
  const FinishScoreValidator();

  FinishScoreValidation validate({
    required int score,
    int? field,
    FinishMultiplier? multiplier,
  }) {
    assert(
      (field == null && multiplier == null) ||
          (field != null && multiplier != null),
      'field and multiplier must either both be provided or both be null',
    );

    if (score <= 0) {
      return const FinishScoreValidation(
        isValid: false,
        errorMessage: 'Der Finish Score muss größer als 0 sein.',
      );
    }

    if (field != null) {
      return _validateWithFinalDart(
        score: score,
        field: field,
        multiplier: multiplier!,
      );
    }

    return _validateGeneralCheckout(score);
  }

  FinishScoreValidation _validateWithFinalDart({
    required int score,
    required int field,
    required FinishMultiplier multiplier,
  }) {
    final finalDartScore = _dartScore(field, multiplier);
    final remaining = score - finalDartScore;

    if (remaining < 0) {
      return const FinishScoreValidation(
        isValid: false,
        errorMessage:
            'Der Finish Score ist für diesen letzten Dart zu niedrig.',
      );
    }

    // Der angegebene letzte Dart muss ein gültiger Checkout-Dart sein:
    // Double, Triple oder Double Bull.
    if (!_possibleFinishingDarts().contains(finalDartScore)) {
      return const FinishScoreValidation(
        isValid: false,
        errorMessage:
            'Der letzte Dart ist kein gültiger Checkout-Dart.',
      );
    }

    if (!_isReachableWithAtMostTwoDarts(remaining)) {
      return const FinishScoreValidation(
        isValid: false,
        errorMessage:
            'Dieser Finish Score kann mit diesem letzten Dart nicht gefinisht werden.',
      );
    }

    return const FinishScoreValidation(isValid: true);
  }

  FinishScoreValidation _validateGeneralCheckout(int score) {
    if (!_isReachableCheckout(score)) {
      return const FinishScoreValidation(
        isValid: false,
        errorMessage: 'Dieser Finish Score kann nicht gefinisht werden.',
      );
    }

    return const FinishScoreValidation(isValid: true);
  }

  bool _isReachableCheckout(int score) {
    final dartScores = _possibleDartScores();
    final finishingDarts = _possibleFinishingDarts();

    // Checkout mit einem Dart.
    if (finishingDarts.contains(score)) {
      return true;
    }

    // Checkout mit zwei Darts:
    // ein beliebiger Dart + Double, Triple oder Double Bull.
    for (final first in dartScores) {
      for (final finish in finishingDarts) {
        if (first + finish == score) {
          return true;
        }
      }
    }

    // Checkout mit drei Darts:
    // zwei beliebige Darts + Double, Triple oder Double Bull.
    for (final first in dartScores) {
      for (final second in dartScores) {
        final remaining = score - first - second;

        if (finishingDarts.contains(remaining)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _isReachableWithAtMostTwoDarts(int score) {
    if (score == 0) {
      return true;
    }

    final dartScores = _possibleDartScores();

    // Checkout mit einem Dart.
    if (dartScores.contains(score)) {
      return true;
    }

    // Checkout mit zwei Darts.
    for (final first in dartScores) {
      if (dartScores.contains(score - first)) {
        return true;
      }
    }

    return false;
  }

  int _dartScore(
    int field,
    FinishMultiplier multiplier,
  ) {
    // Bull: Single Bull = 25, Double Bull = 50.
    if (field == 25) {
      return multiplier == FinishMultiplier.double ? 50 : 25;
    }

    return field * multiplier.factor;
  }

  Set<int> _possibleDartScores() {
    return {
      0,
      ...List.generate(20, (index) => index + 1),
      ...List.generate(20, (index) => (index + 1) * 2),
      ...List.generate(20, (index) => (index + 1) * 3),
      25,
      50,
    };
  }

  Set<int> _possibleFinishingDarts() {
    return {
      // Double 1–20
      ...List.generate(20, (index) => (index + 1) * 2),

      // Triple 1–20
      ...List.generate(20, (index) => (index + 1) * 3),

      // Double Bull
      50,
    };
  }
}