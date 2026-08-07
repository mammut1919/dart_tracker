enum DateFilter {
  today,
  last7Days,
  last30Days,
  last90Days,
  last180Days,
  last365Days,
  allTime,
}

extension DateFilterExtension on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.allTime:
        return 'Gesamt';
      case DateFilter.today:
        return 'Heute';
      case DateFilter.last7Days:
        return '7 Tage';
      case DateFilter.last30Days:
        return '30 Tage';
      case DateFilter.last90Days:
        return '3 Monate';
      case DateFilter.last180Days:
        return '6 Monate';
      case DateFilter.last365Days:
        return '1 Jahr';
    }
  }

  bool get includesBaseline => this == DateFilter.allTime;

  DateTime? get startDate {
    final now = DateTime.now();

    DateTime normalize(DateTime date) {
      return DateTime(
        date.year,
        date.month,
        date.day,
      );
    }

    switch (this) {
      case DateFilter.allTime:
        return null;

      case DateFilter.today:
        return normalize(now);

      case DateFilter.last7Days:
        return normalize(
          now.subtract(const Duration(days: 7)),
        );

      case DateFilter.last30Days:
        return normalize(
          now.subtract(const Duration(days: 30)),
        );

      case DateFilter.last90Days:
        return normalize(
          now.subtract(const Duration(days: 90)),
        );

      case DateFilter.last180Days:
        return normalize(
          now.subtract(const Duration(days: 180)),
        );

      case DateFilter.last365Days:
        return normalize(
          now.subtract(const Duration(days: 365)),
        );
    }
  }
}