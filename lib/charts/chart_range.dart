import '../models/new_entry.dart';

class ChartRange {
  const ChartRange({
    required this.firstDate,
    required this.lastDate,
  });

  factory ChartRange.fromEntries(List<NewEntry> entries) {
    if (entries.isEmpty) {
      final now = DateTime.now();

      return ChartRange(
        firstDate: now,
        lastDate: now.add(const Duration(days: 1)),
      );
    }

    final firstDate = entries
        .map((e) => e.timestamp)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final lastDate = entries
        .map((e) => e.timestamp)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final today = DateTime.now();

    final chartEnd = lastDate.isBefore(today)
        ? today
        : lastDate.add(const Duration(days: 1));

    return ChartRange(
      firstDate: firstDate.subtract(const Duration(days: 1)),
      lastDate: chartEnd,
    );
  }

  final DateTime firstDate;
  final DateTime lastDate;

  double get maxX =>
      lastDate.difference(firstDate).inDays.toDouble();

  DateTime dateAt(double x) {
    return firstDate.add(
      Duration(days: x.round()),
    );
  }
}