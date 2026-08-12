enum ChartTimeIntervalType {
  days,
  months,
}

class ChartTimeInterval {
  const ChartTimeInterval({
    required this.type,
    required this.amount,
  });

  final ChartTimeIntervalType type;
  final int amount;
}

class ChartScale {
  const ChartScale._();

  static ChartTimeInterval calculateXInterval(
    int totalDays,
  ) {
    if (totalDays <= 7) {
      return const ChartTimeInterval(
        type: ChartTimeIntervalType.days,
        amount: 2,
      );
    }

    if (totalDays <= 30) {
      return const ChartTimeInterval(
        type: ChartTimeIntervalType.days,
        amount: 7,
      );
    }

    if (totalDays <= 90) {
      return const ChartTimeInterval(
        type: ChartTimeIntervalType.months,
        amount: 1,
      );
    }

    if (totalDays <= 180) {
      return const ChartTimeInterval(
        type: ChartTimeIntervalType.months,
        amount: 2,
      );
    }

    return const ChartTimeInterval(
      type: ChartTimeIntervalType.months,
      amount: 4,
    );
  }

  static List<DateTime> buildXTickDates({
    required DateTime firstDate,
    required DateTime lastDate,
    required ChartTimeInterval interval,
  }) {
    final result = <DateTime>[];

    if (interval.type == ChartTimeIntervalType.days) {
      var date = firstDate;

      while (!date.isAfter(lastDate)) {
        result.add(date);

        date = date.add(
          Duration(days: interval.amount),
        );
      }

      if (result.isEmpty ||
          result.last != lastDate &&
          lastDate.difference(result.last).inDays >= interval.amount) {
        result.add(lastDate);
      }

      return result;
    }

    // Ersten tatsächlichen Datenpunkt als Tick verwenden.
    result.add(firstDate);

    var date = DateTime(
      firstDate.year,
      firstDate.month,
      1,
    );

    while (date.isBefore(firstDate)) {
      date = DateTime(
        date.year,
        date.month + interval.amount,
      );
    }

    while (!date.isAfter(lastDate)) {
      final distance = date.difference(result.last).inDays;

      // Nur hinzufügen, wenn der neue Tick nicht zu dicht
      // am vorherigen Tick liegt.
      if (distance >= 14) {
        result.add(date);
      }

      date = DateTime(
        date.year,
        date.month + interval.amount,
      );
    }

    return result;
  }

  static double calculateYInterval(
    double minY,
    double maxY,
  ) {
    final range = maxY - minY;

    if (range <= 10) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 200) return 20;

    return 50;
  }

  static double calculateChartMaxY(
    double maxValue,
    double interval,
  ) {
    return ((maxValue + 1) / interval).ceil() * interval;
  }
}