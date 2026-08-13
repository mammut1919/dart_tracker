import '../models/average_finish_point.dart';
import '../models/finish_multiplier.dart';
import '../models/finish_point.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';

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

    for (final finish in finishes) {
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
}