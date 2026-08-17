import '../models/new_entry.dart';

class ChartRange {
  const ChartRange({required this.firstDate, required this.lastDate});

  factory ChartRange.fromEntries(List<NewEntry> entries) {
    return ChartRange.fromDates(entries.map((entry) => entry.timestamp));
  }

  factory ChartRange.fromDates(Iterable<DateTime> dates) {
    final timestamps = dates.toList();

    if (timestamps.isEmpty) {
      final now = DateTime.now();

      return ChartRange(
        firstDate: now,
        lastDate: now.add(const Duration(days: 1)),
      );
    }

    final firstDate = timestamps
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final lastDate = timestamps
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final today = DateTime.now();

    final baseEnd = lastDate.isAfter(today) ? lastDate : today;

    final chartEnd = baseEnd.add(const Duration(days: 1));

    return ChartRange(
      firstDate: firstDate.subtract(const Duration(days: 1)),
      lastDate: chartEnd,
    );
  }

  final DateTime firstDate;
  final DateTime lastDate;

  double get maxX => lastDate.difference(firstDate).inDays.toDouble();

  DateTime dateAt(double x) {
    return firstDate.add(Duration(days: x.round()));
  }
}
