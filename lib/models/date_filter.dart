enum DateFilter {
  allTime,
  today,
  last7Days,
  last30Days,
  last365Days,
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
      case DateFilter.last365Days:
        return '365 Tage';
    }
  }

  bool get includesBaseline => this == DateFilter.allTime;

  DateTime? get startDate {
    final now = DateTime.now();

    switch (this) {
      case DateFilter.allTime:
        return null;
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day);
      case DateFilter.last7Days:
        return now.subtract(const Duration(days: 7));
      case DateFilter.last30Days:
        return now.subtract(const Duration(days: 30));
      case DateFilter.last365Days:
        return now.subtract(const Duration(days: 365));
    }
  }
}