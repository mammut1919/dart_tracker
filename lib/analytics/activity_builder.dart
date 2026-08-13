import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';
import 'activity_point.dart';

class ActivityBuilder {
  const ActivityBuilder();

  List<ActivityPoint> buildActivityData({
    required List<NewFinishEntry> finishes,
    DateTime? startDate,
    StatisticsAggregation aggregation = StatisticsAggregation.day,
  }) {
    if (finishes.isEmpty) {
      return [];
    }

    final grouped = <DateTime, int>{};

    for (final finish in finishes) {
      final date = DateTime(
        finish.timestamp.year,
        finish.timestamp.month,
        finish.timestamp.day,
      );

      final key = _periodStart(date, aggregation);

      grouped.update(
        key,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final firstPeriod = startDate != null
        ? _periodStart(
            DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            ),
            aggregation,
          )
        : grouped.keys.reduce(
            (a, b) => a.isBefore(b) ? a : b,
          );

    final now = DateTime.now();

    final lastPeriod = _periodStart(
      DateTime(
        now.year,
        now.month,
        now.day,
      ),
      aggregation,
    );

    final result = <ActivityPoint>[];

    for (
      var period = firstPeriod;
      !period.isAfter(lastPeriod);
      period = _nextPeriod(period, aggregation)
    ) {
      result.add(
        ActivityPoint(
          date: period,
          finishes: grouped[period] ?? 0,
        ),
      );
    }

    return result;
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

  DateTime _nextPeriod(
    DateTime period,
    StatisticsAggregation aggregation,
  ) {
    switch (aggregation) {
      case StatisticsAggregation.day:
        return DateTime(
          period.year,
          period.month,
          period.day + 1,
        );

      case StatisticsAggregation.week:
        return DateTime(
          period.year,
          period.month,
          period.day + 7,
        );

      case StatisticsAggregation.month:
        return DateTime(
          period.year,
          period.month + 1,
        );

      case StatisticsAggregation.year:
        return DateTime(
          period.year + 1,
        );
    }
  }
}