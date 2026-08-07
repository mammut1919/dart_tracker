import 'package:intl/intl.dart';

import '../models/date_filter.dart';

class ChartAxis {
  const ChartAxis._();

  static String formatDate(
    DateTime date,
    DateFilter filter,
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
        return DateFormat('yyyy').format(date);
    }
  }

  static bool shouldShowLabel({
    required int index,
    required DateTime date,
    required DateFilter filter,
  }) {
    switch (filter) {
      case DateFilter.today:
        return true;

      case DateFilter.last7Days:
        return index % 2 == 0;

      case DateFilter.last30Days:
        return index % 15 == 0;

      case DateFilter.last90Days:
        return index % 15 == 0;

      case DateFilter.last180Days:
        return index % 30 == 0;

      case DateFilter.last365Days:
        return index % 30 == 0;

      case DateFilter.allTime:
        return index % 30 == 0;
    }
  }
}