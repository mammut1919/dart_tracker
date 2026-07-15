import '../database/database.dart';
import 'chart_data.dart';
import 'chart_point.dart';

class ChartBuilder {
  const ChartBuilder();

  ChartData buildStepChart({
    required List<ScoreEntry> entries,
    required int score,
    required int baseline,
    required DateTime chartStart,
    required DateTime chartEnd,
  }) {
    final filtered = entries
        .where((e) => e.score == score)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final points = <ChartPoint>[];

    var current = baseline;

    // Baseline am linken Rand
    points.add(
      ChartPoint(
        x: 0,
        y: current.toDouble(),
      ),
    );

    for (final entry in filtered) {
      final x = entry.timestamp
          .difference(chartStart)
          .inDays
          .toDouble();

      // waagerechte Linie bis zum Treffer
      points.add(
        ChartPoint(
          x: x,
          y: current.toDouble(),
        ),
      );

      current++;

      // senkrechter Sprung
      points.add(
        ChartPoint(
          x: x,
          y: current.toDouble(),
        ),
      );
    }

    // Linie bis zum rechten Diagrammrand verlängern
    final endX = chartEnd
        .difference(chartStart)
        .inDays
        .toDouble();

    points.add(
      ChartPoint(
        x: endX,
        y: current.toDouble(),
      ),
    );

    return ChartData(
      points: points,
      firstDate: chartStart,
      lastDate: chartEnd,
    );
  }
}