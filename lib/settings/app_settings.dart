import 'package:flutter/material.dart';

import '../models/entry_type.dart';

class AppSettings {
  static const initial = AppSettings(
    baseline180: 0,
    baseline171: 0,
    baseline162: 0,
    baselineHighFinish: 0,
    baselineShortLeg: 0,

    score180ColorValue: 0xFF4CAF50,
    score171ColorValue: 0xFFFF9800,
    score162ColorValue: 0xFF0000FF,
    highFinishColorValue: 0xFF673AB7,
    shortLegColorValue: 0xFFF44336,
  );

  const AppSettings({
    required this.baseline180,
    required this.baseline171,
    required this.baseline162,
    required this.baselineHighFinish,
    required this.baselineShortLeg,
    required this.score180ColorValue,
    required this.score171ColorValue,
    required this.score162ColorValue,
    required this.highFinishColorValue,
    required this.shortLegColorValue,
  }) : assert(baseline180 >= 0),
       assert(baseline171 >= 0),
       assert(baseline162 >= 0),
       assert(baselineHighFinish >= 0),
       assert(baselineShortLeg >= 0);

  final int baseline180;
  final int baseline171;
  final int baseline162;
  final int baselineHighFinish;
  final int baselineShortLeg;
  final int score180ColorValue;
  final int score171ColorValue;
  final int score162ColorValue;
  final int highFinishColorValue;
  final int shortLegColorValue;

  Color get score180Color => Color(score180ColorValue);
  Color get score171Color => Color(score171ColorValue);
  Color get score162Color => Color(score162ColorValue);
  Color get highFinishColor => Color(highFinishColorValue);
  Color get shortLegColor => Color(shortLegColorValue);

  AppSettings copyWith({
    int? baseline180,
    int? baseline171,
    int? baseline162,
    int? baselineHighFinish,
    int? baselineShortLeg,
    int? score180ColorValue,
    int? score171ColorValue,
    int? score162ColorValue,
    int? highFinishColorValue,
    int? shortLegColorValue,
  }) {
    return AppSettings(
      baseline180: baseline180 ?? this.baseline180,
      baseline171: baseline171 ?? this.baseline171,
      baseline162: baseline162 ?? this.baseline162,
      baselineHighFinish: baselineHighFinish ?? this.baselineHighFinish,
      baselineShortLeg: baselineShortLeg ?? this.baselineShortLeg,
      score180ColorValue: score180ColorValue ?? this.score180ColorValue,
      score171ColorValue: score171ColorValue ?? this.score171ColorValue,
      score162ColorValue: score162ColorValue ?? this.score162ColorValue,
      highFinishColorValue: highFinishColorValue ?? this.highFinishColorValue,
      shortLegColorValue: shortLegColorValue ?? this.shortLegColorValue,
    );
  }

  Color colorFor(int score) {
    switch (score) {
      case 180:
        return score180Color;

      case 171:
        return score171Color;

      case 162:
        return score162Color;

      default:
        throw ArgumentError('Unknown score: $score');
    }
  }

  Color colorForEntryType(EntryType type) {
    switch (type) {
      case EntryType.highFinish:
        return highFinishColor;

      case EntryType.shortLeg:
        return shortLegColor;

      default:
        throw ArgumentError('Unknown entry type: $type');
    }
  }

  int baselineFor(int score) {
    switch (score) {
      case 180:
        return baseline180;
      case 171:
        return baseline171;
      case 162:
        return baseline162;
      default:
        throw ArgumentError('Unknown score: $score');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'baseline180': baseline180,
      'baseline171': baseline171,
      'baseline162': baseline162,
      'baselineHighFinish': baselineHighFinish,
      'baselineShortLeg': baselineShortLeg,
      'score180ColorValue': score180ColorValue,
      'score171ColorValue': score171ColorValue,
      'score162ColorValue': score162ColorValue,
      'highFinishColorValue': highFinishColorValue,
      'shortLegColorValue': shortLegColorValue,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      baseline180: json['baseline180'] as int,
      baseline171: json['baseline171'] as int,
      baseline162: json['baseline162'] as int,
      baselineHighFinish: json['baselineHighFinish'] as int? ?? 0,
      baselineShortLeg: json['baselineShortLeg'] as int? ?? 0,
      score180ColorValue: json['score180ColorValue'] as int? ??
          AppSettings.initial.score180ColorValue,
      score171ColorValue: json['score171ColorValue'] as int? ??
          AppSettings.initial.score171ColorValue,
      score162ColorValue: json['score162ColorValue'] as int? ??
          AppSettings.initial.score162ColorValue,
      highFinishColorValue: json['highFinishColorValue'] as int? ??
          AppSettings.initial.highFinishColorValue,
      shortLegColorValue: json['shortLegColorValue'] as int? ??
          AppSettings.initial.shortLegColorValue,
    );
  }
}
