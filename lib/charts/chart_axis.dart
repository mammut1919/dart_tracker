import 'package:intl/intl.dart';

import '../models/date_filter.dart';
import '../models/statistics_aggregation.dart';

class ChartAxis {
  const ChartAxis._();

  static String formatDate(
    DateTime date,
    DateFilter filter, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    switch (filter) {
      case DateFilter.today:
      case DateFilter.last7Days:
      case DateFilter.last30Days:
        return DateFormat('dd.MM').format(date);

      case DateFilter.last90Days:
      case DateFilter.last180Days:
        return DateFormat('MMM', 'de_DE').format(date);
      case DateFilter.last365Days:
        return DateFormat('MMM yy', 'de_DE').format(date);

      case DateFilter.allTime:
        final rangeInDays = lastDate.difference(firstDate).inDays;

        if (rangeInDays <= 60) {
          return DateFormat('dd.MM').format(date);
        }

        final twoYearsAfterFirstDate = DateTime(
          firstDate.year + 2,
          firstDate.month,
          firstDate.day,
        );

        if (lastDate.isBefore(twoYearsAfterFirstDate)) {
          return DateFormat('MMM yy', 'de_DE').format(date);
        }

        return DateFormat('yyyy').format(date);
    }
  }

  static bool shouldShowLabel({
    required int index,
    required int pointCount,
    DateFilter? filter,
    StatisticsAggregation? aggregation,
  }) {
    if (pointCount <= 1) {
      return true;
    }

    if (aggregation != null) {
      const targetCount = 7;

      final interval =
          ((pointCount - 1) / (targetCount - 1)).ceil();

      return index == 0 ||
          index == pointCount - 1 ||
          index % interval == 0;
    }

    final targetCount = switch (filter!) {
      DateFilter.today => pointCount,
      DateFilter.last7Days => 5,
      DateFilter.last30Days => 7,
      DateFilter.last90Days => 7,
      DateFilter.last180Days => 7,
      DateFilter.last365Days => 7,
      DateFilter.allTime => pointCount <= 31 ? 5 : 7,
    };

    final interval =
        ((pointCount - 1) / (targetCount - 1)).ceil();

    return index == 0 ||
        index == pointCount - 1 ||
        index % interval == 0;
  }

  static bool shouldShowTimeLabel({
    required int dayOffset,
    required int totalDays,
    required DateFilter filter,
  }) {
    if (totalDays <= 1) {
      return true;
    }

    final targetCount = switch (filter) {
      DateFilter.today => totalDays,
      DateFilter.last7Days => 5,
      DateFilter.last30Days => 7,
      DateFilter.last90Days => 7,
      DateFilter.last180Days => 7,
      DateFilter.last365Days => 7,
      DateFilter.allTime => totalDays <= 31 ? 5 : 7,
    };

    final interval =
        ((totalDays - 1) / (targetCount - 1)).ceil();

    return dayOffset == 0 ||
        dayOffset >= totalDays - 1 ||
        dayOffset % interval == 0;
  }

  static String formatAggregationDate(
    DateTime date,
    StatisticsAggregation aggregation,
  ) {
    switch (aggregation) {
      case StatisticsAggregation.day:
        return DateFormat('dd.MM').format(date);

      case StatisticsAggregation.week:
        return DateFormat('dd.MM').format(date);

      case StatisticsAggregation.month:
        return DateFormat('MMM', 'de_DE').format(date);

      case StatisticsAggregation.year:
        return DateFormat('yyyy').format(date);
    }
  }

  static String formatTooltipDate(
    DateTime date,
    StatisticsAggregation aggregation,
  ) {
    switch (aggregation) {
      case StatisticsAggregation.day:
        return DateFormat('dd.MM.yyyy').format(date);

      case StatisticsAggregation.week:
        final endDate = date.add(const Duration(days: 6));

        return '${DateFormat('dd.MM.yyyy').format(date)}'
            ' – '
            '${DateFormat('dd.MM.yyyy').format(endDate)}';

      case StatisticsAggregation.month:
        return DateFormat('MMMM yyyy', 'de_DE').format(date);

      case StatisticsAggregation.year:
        return DateFormat('yyyy').format(date);
    }
  }
}