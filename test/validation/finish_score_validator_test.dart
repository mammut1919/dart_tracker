import 'package:flutter_test/flutter_test.dart';

import 'package:dart_tracker/models/finish_multiplier.dart';
import 'package:dart_tracker/validation/finish_score_validator.dart';

void main() {
  const validator = FinishScoreValidator();

  group('allgemeine Checkout-Validierung', () {
    test('170 ist gültig', () {
      expect(
        validator.validate(score: 170).isValid,
        isTrue,
      );
    });

    test('167 ist gültig', () {
      expect(
        validator.validate(score: 167).isValid,
        isTrue,
      );
    });

    test('165 ist gültig', () {
      expect(
        validator.validate(score: 165).isValid,
        isTrue,
      );
    });

    test('168 ist gültig', () {
      expect(
        validator.validate(score: 168).isValid,
        isTrue,
      );
    });

    test('169 ist ungültig', () {
      expect(
        validator.validate(score: 169).isValid,
        isFalse,
      );
    });

    test('180 ist gültig', () {
      expect(
        validator.validate(score: 180).isValid,
        isTrue,
      );
    });

    test('181 ist ungültig', () {
      expect(
        validator.validate(score: 181).isValid,
        isFalse,
      );
    });
  });

  group('konkreter letzter Dart', () {
    test('D8 kann 16 finishen', () {
      expect(
        validator
            .validate(
              score: 16,
              field: 8,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('D8 kann 17 finishen', () {
      expect(
        validator
            .validate(
              score: 17,
              field: 8,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('D8 kann 15 nicht finishen', () {
      expect(
        validator
            .validate(
              score: 15,
              field: 8,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isFalse,
      );
    });

    test('D20 kann 40 finishen', () {
      expect(
        validator
            .validate(
              score: 40,
              field: 20,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('D20 kann 41 finishen', () {
      expect(
        validator
            .validate(
              score: 41,
              field: 20,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('D20 kann 39 nicht finishen', () {
      expect(
        validator
            .validate(
              score: 39,
              field: 20,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isFalse,
      );
    });

    test('D20 kann 170 nicht finishen', () {
      expect(
        validator
            .validate(
              score: 170,
              field: 20,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isFalse,
      );
    });

    test('T20 kann 180 finishen', () {
      expect(
        validator
            .validate(
              score: 180,
              field: 20,
              multiplier: FinishMultiplier.triple,
            )
            .isValid,
        isTrue,
      );
    });

    test('T20 kann 181 nicht finishen', () {
      expect(
        validator
            .validate(
              score: 181,
              field: 20,
              multiplier: FinishMultiplier.triple,
            )
            .isValid,
        isFalse,
      );
    });
  });

  group('Bull', () {
    test('Double Bull kann 50 finishen', () {
      expect(
        validator
            .validate(
              score: 50,
              field: 25,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('Double Bull kann 100 finishen', () {
      expect(
        validator
            .validate(
              score: 100,
              field: 25,
              multiplier: FinishMultiplier.double,
            )
            .isValid,
        isTrue,
      );
    });

    test('Triple Bull ist kein gültiger Abschluss', () {
      expect(
        validator
            .validate(
              score: 75,
              field: 25,
              multiplier: FinishMultiplier.triple,
            )
            .isValid,
        isFalse,
      );
    });
  });

  group('ungültige Scores', () {
    test('0 ist ungültig', () {
      expect(
        validator.validate(score: 0).isValid,
        isFalse,
      );
    });

    test('negativer Score ist ungültig', () {
      expect(
        validator.validate(score: -1).isValid,
        isFalse,
      );
    });
  });
}