import '../models/average_finish_point.dart';
import '../models/date_filter.dart';
import '../models/entry_type.dart';
import '../models/finish_multiplier.dart';
import '../models/finish_point.dart';
import '../models/new_entry.dart';
import '../models/new_finish_entry.dart';
import '../models/personal_bests.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';



class AnalyticsBuilder {
  const AnalyticsBuilder();

  List<AverageFinishPoint> _buildAverageData({
    required List<NewFinishEntry> finishes,
    required StatisticsAggregation aggregation,
    required double? Function(NewFinishEntry finish) scoreProvider,
  }) {
    if (finishes.isEmpty) {
      return [];
    }

    final grouped = <DateTime, List<double>>{};

    for (final finish in finishes) {
      final score = scoreProvider(finish);

      if (score == null) {
        continue;
      }

      final date = DateTime(
        finish.timestamp.year,
        finish.timestamp.month,
        finish.timestamp.day,
      );

      final key = _periodStart(date, aggregation);

      grouped.putIfAbsent(key, () => []).add(score);
    }

    final points = grouped.entries.map((entry) {
      final values = entry.value;

      final average =
          values.reduce((a, b) => a + b) / values.length;

      return AverageFinishPoint(
        date: entry.key,
        average: average,
      );
    }).toList();

    points.sort((a, b) => a.date.compareTo(b.date));

    return points;
  }

  List<AverageFinishPoint> buildAverageLastDartData({
    required List<NewFinishEntry> finishes,
    StatisticsAggregation aggregation = StatisticsAggregation.day,
  }) {
    return _buildAverageData(
      finishes: finishes,
      aggregation: aggregation,
      scoreProvider: (finish) =>
          (finish.field * finish.multiplier.factor).toDouble(),
    );
  }

  List<AverageFinishPoint> buildAverageFinishData({
    required List<NewFinishEntry> finishes,
    StatisticsAggregation aggregation = StatisticsAggregation.day,
  }) {
    return _buildAverageData(
      finishes: finishes,
      aggregation: aggregation,
      scoreProvider: (finish) => finish.score?.toDouble(),
    );
  }

  DateTime _periodStart(
    DateTime date,
    StatisticsAggregation aggregation,
  ) {
    switch (aggregation) {
      case StatisticsAggregation.day:
        return DateTime(
          date.year,
          date.month,
          date.day,
        );

      case StatisticsAggregation.week:
        final day = DateTime(
          date.year,
          date.month,
          date.day,
        );

        return day.subtract(
          Duration(days: day.weekday - DateTime.monday),
        );

      case StatisticsAggregation.month:
        return DateTime(
          date.year,
          date.month,
        );

      case StatisticsAggregation.year:
        return DateTime(
          date.year,
        );
    }
  }

  List<FinishPoint> buildFinishData({
    required List<NewFinishEntry> finishes,
  }) {
    final points = <FinishPoint>[];

    for (final finish in finishes.reversed) {
      final score = finish.score;

      if (score == null) {
        continue;
      }

      points.add(
        FinishPoint(
          index: points.length + 1,
          date: finish.timestamp,
          score: score.toDouble(),
        ),
      );
    }

    return points;
  }

  String _formatFinishField(NewFinishEntry finish) {
    if (finish.field == 25) {
      return 'Bull';
    }

    switch (finish.multiplier) {
      case FinishMultiplier.single:
        return 'S${finish.field}';

      case FinishMultiplier.double:
        return 'D${finish.field}';

      case FinishMultiplier.triple:
        return 'T${finish.field}';
    }
  }

  Map<T, int> _findMostFrequent<T>(Map<T, int> counts) {
    if (counts.isEmpty) {
      return {};
    }

    final maxCount =
        counts.values.reduce((a, b) => a > b ? a : b);

    return Map.fromEntries(
      counts.entries.where(
        (entry) => entry.value == maxCount,
      ),
    );
  }

  PersonalBests buildPersonalBests({
    required List<NewEntry> entries,
    required List<NewFinishEntry> finishes,
    required AppSettings settings,
    required DateFilter selectedDateFilter,
  }) {
    final finishScores = finishes
        .where((finish) => finish.score != null)
        .map((finish) => finish.score!)
        .toList();

    final finishCount = finishes.length;

    final highestFinish = finishScores.isEmpty
        ? null
        : finishScores.reduce((a, b) => a > b ? a : b);

    final raw180 = entries.where(
      (entry) =>
          entry.type == EntryType.score &&
          entry.value == 180,
    ).length;

    final raw171 = entries.where(
      (entry) =>
          entry.type == EntryType.score &&
          entry.value == 171,
    ).length;

    final raw162 = entries.where(
      (entry) =>
          entry.type == EntryType.score &&
          entry.value == 162,
    ).length;

    final rawHighFinish = entries
        .where((entry) => entry.type == EntryType.highFinish)
        .length;

    final rawShortLeg = entries.where(
      (entry) =>
          entry.type == EntryType.shortLeg &&
          entry.value <= settings.shortLegLimit,
    ).length;

    final includeBaseline = selectedDateFilter.includesBaseline;

    final count180 =
        raw180 +
        (includeBaseline ? settings.baselineFor(180) : 0);

    final count171 =
        raw171 +
        (includeBaseline ? settings.baselineFor(171) : 0);

    final count162 =
        raw162 +
        (includeBaseline ? settings.baselineFor(162) : 0);

    final highFinishCount =
        rawHighFinish +
        (includeBaseline ? settings.baselineHighFinish : 0);

    final shortLegCount =
        rawShortLeg +
        (includeBaseline ? settings.baselineShortLeg : 0);

    NewFinishEntry? highestLastDart;

    for (final finish in finishes) {
      final value =
          finish.field * finish.multiplier.factor;

      if (highestLastDart == null ||
          value >
              highestLastDart.field *
                  highestLastDart.multiplier.factor) {
        highestLastDart = finish;
      }
    }

    final shortLegEntries = entries.where(
      (entry) =>
          entry.type == EntryType.shortLeg &&
          entry.value <= settings.shortLegLimit,
    );

    final shortestShortLeg = shortLegEntries.isEmpty
        ? null
        : shortLegEntries
            .map((entry) => entry.value)
            .reduce((a, b) => a < b ? a : b);

    final finishFieldCounts = <String, int>{};

    for (final finish in finishes) {
      final field = _formatFinishField(finish);

      finishFieldCounts[field] =
          (finishFieldCounts[field] ?? 0) + 1;
    }

    final finishScoreCounts = <int, int>{};

    for (final score in finishScores) {
      finishScoreCounts[score] =
          (finishScoreCounts[score] ?? 0) + 1;
    }

    final mostFrequentFinishFields =
        _findMostFrequent(finishFieldCounts);

    final mostFrequentFinishes =
        _findMostFrequent(finishScoreCounts);

    return PersonalBests(
      finishCount: finishCount,
      highestFinish: highestFinish,
      highFinishCount: highFinishCount,
      highestLastDart: highestLastDart,
      shortestShortLeg: shortestShortLeg,
      shortLegCount: shortLegCount,
      count180: count180,
      count171: count171,
      count162: count162,
      mostFrequentFinishFields:
          mostFrequentFinishFields.keys.toList(),
      mostFrequentFinishFieldCount:
          mostFrequentFinishFields.isEmpty
              ? null
              : mostFrequentFinishFields.values.first,
      mostFrequentFinishes:
          mostFrequentFinishes.keys.toList(),
      mostFrequentFinishCount:
          mostFrequentFinishes.isEmpty
              ? null
              : mostFrequentFinishes.values.first,
    );
  }
}