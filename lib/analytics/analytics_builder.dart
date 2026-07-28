import '../models/average_finish_point.dart';
import '../models/new_finish_entry.dart';
import '../models/finish_multiplier.dart';

class AnalyticsBuilder {
  const AnalyticsBuilder();

  List<AverageFinishPoint> buildAverageFinishData({
    required List<NewFinishEntry> finishes,
  }) {
    final grouped = <DateTime, List<int>>{};

    for (final finish in finishes) {
      final date = DateTime(
        finish.timestamp.year,
        finish.timestamp.month,
        finish.timestamp.day,
      );

      final score = finish.field * finish.multiplier.factor;

      grouped.putIfAbsent(date, () => []).add(score);
    }

    final points =
        grouped.entries.map((entry) {
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
}