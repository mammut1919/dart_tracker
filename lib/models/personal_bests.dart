import 'package:flutter/foundation.dart';

import 'new_finish_entry.dart';

@immutable
class PersonalBests {
  const PersonalBests({
    required this.finishCount,
    required this.highestFinish,
    required this.highFinishCount,
    required this.highestLastDart,
    required this.shortestShortLeg,
    required this.shortLegCount,
    required this.count180,
    required this.count171,
    required this.count162,
    required this.mostFrequentFinishFields,
    required this.mostFrequentFinishFieldCount,
    required this.mostFrequentFinishes,
    required this.mostFrequentFinishCount,
  });

  final int finishCount;
  final int? highestFinish;
  final int highFinishCount;
  final NewFinishEntry? highestLastDart;
  final int? shortestShortLeg;
  final int shortLegCount;
  final int count180;
  final int count171;
  final int count162;

  final List<String> mostFrequentFinishFields;
  final int? mostFrequentFinishFieldCount;

  final List<int> mostFrequentFinishes;
  final int? mostFrequentFinishCount;
}