class AppSettings {
  static const initial = AppSettings(
    baseline180: 0,
    baseline171: 0,
    baseline162: 0,
    baselineHighFinish: 0,
    baselineShortLeg: 0,
  );

  const AppSettings({
    required this.baseline180,
    required this.baseline171,
    required this.baseline162,
    required this.baselineHighFinish,
    required this.baselineShortLeg,
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

  AppSettings copyWith({
    int? baseline180,
    int? baseline171,
    int? baseline162,
    int? baselineHighFinish,
    int? baselineShortLeg,
  }) {
    return AppSettings(
      baseline180: baseline180 ?? this.baseline180,
      baseline171: baseline171 ?? this.baseline171,
      baseline162: baseline162 ?? this.baseline162,
      baselineHighFinish: baselineHighFinish ?? this.baselineHighFinish,
      baselineShortLeg: baselineShortLeg ?? this.baselineShortLeg,
    );
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
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      baseline180: json['baseline180'] as int,
      baseline171: json['baseline171'] as int,
      baseline162: json['baseline162'] as int,
      baselineHighFinish: json['baselineHighFinish'] as int? ?? 0,
      baselineShortLeg: json['baselineShortLeg'] as int? ?? 0,
    );
  }
}
