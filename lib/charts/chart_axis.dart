import 'package:intl/intl.dart';

import '../models/date_filter.dart';

class ChartAxis {
  const ChartAxis._();

  static String formatDate(
    DateTime date,
    DateFilter filter, {
    required DateTime firstDate,
    required DateTime lastDate,
  }
  ) {
    switch (filter) {
      case DateFilter.today:
      case DateFilter.last7Days:
      case DateFilter.last30Days:
        return DateFormat('dd.MM').format(date);

      case DateFilter.last90Days:
      case DateFilter.last180Days:
        return DateFormat('MM.yy').format(date);

      case DateFilter.last365Days:
        return DateFormat('MMM').format(date);

      case DateFilter.allTime:
        final twoYearsAfterFirstDate = DateTime(
          firstDate.year + 2,
          firstDate.month,
          firstDate.day,
        );

        if (lastDate.isBefore(twoYearsAfterFirstDate)) {
          return DateFormat('MMM.yy').format(date);
        }

        return DateFormat('yyyy').format(date);
    }
  }

  static bool shouldShowLabel({
    required int index,
    required int pointCount,
    required DateFilter filter,
  }) {
    if (pointCount <= 1) {
      return true;
    }

    final targetCount = switch (filter) {
      DateFilter.today => pointCount,
      DateFilter.last7Days => 5,
      DateFilter.last30Days => 7,
      DateFilter.last90Days => 7,
      DateFilter.last180Days => 7,
      DateFilter.last365Days => 7,
      DateFilter.allTime => pointCount <= 31 ? 5 : 7,
    };

    final interval = ((pointCount - 1) / (targetCount - 1)).ceil();

    return index == 0 || index == pointCount - 1 || index % interval == 0;
  }
}
