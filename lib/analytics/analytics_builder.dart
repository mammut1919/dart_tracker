import '../models/average_finish_point.dart';
import '../models/finish_multiplier.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';

class AnalyticsBuilder {
  const AnalyticsBuilder();

  List<AverageFinishPoint> buildAverageFinishData({
    required List<NewFinishEntry> finishes,
    StatisticsAggregation aggregation = StatisticsAggregation.day,
  }) {
    if (finishes.isEmpty) {
      return [];
    }

    final grouped = <DateTime, List<double>>{};

    for (final finish in finishes) {
      final date = DateTime(
        finish.timestamp.year,
        finish.timestamp.month,
        finish.timestamp.day,
      );

      final key = _periodStart(date, aggregation);

      final score = (finish.field * finish.multiplier.factor).toDouble();

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
}