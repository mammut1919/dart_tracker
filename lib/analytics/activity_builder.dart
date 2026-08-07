import '../models/new_finish_entry.dart';
import 'activity_point.dart';

class ActivityBuilder {
  const ActivityBuilder();

  List<ActivityPoint> buildActivityData({
    required List<NewFinishEntry> finishes,
  }) {
    if (finishes.isEmpty) {
      return [];
    }

    final grouped = <DateTime, int>{};

    for (final finish in finishes) {
      final day = DateTime(
        finish.timestamp.year,
        finish.timestamp.month,
        finish.timestamp.day,
      );

      grouped.update(
        day,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final firstDay = grouped.keys.reduce(
      (a, b) => a.isBefore(b) ? a : b,
    );

    final now = DateTime.now();

    final lastDay = DateTime(
      now.year,
      now.month,
      now.day,
    );
    
    final result = <ActivityPoint>[];

    for (
      var day = firstDay;
      !day.isAfter(lastDay);
      day = day.add(const Duration(days: 1))
    ) {
      result.add(
        ActivityPoint(
          date: day,
          finishes: grouped[day] ?? 0,
        ),
      );
    }

    return result;
  }
}