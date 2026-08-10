import '../models/new_finish_entry.dart';
import 'activity_point.dart';

class ActivityBuilder {
  const ActivityBuilder();

  List<ActivityPoint> buildActivityData({
    required List<NewFinishEntry> finishes,
    DateTime? startDate,
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

    final firstDay = startDate != null
        ? DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          )
        : grouped.keys.reduce(
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
      day = DateTime(day.year, day.month, day.day + 1)
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
