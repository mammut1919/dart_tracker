import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../analytics/analytics_builder.dart';
import '../charts/chart_axis.dart';
import '../charts/chart_scale.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';
import '../widgets/statistics_line_chart.dart';

class FinishesChart extends StatelessWidget {
  const FinishesChart({
    super.key,
    required this.finishes,
    required this.settings,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final builder = const AnalyticsBuilder();

    final points = builder.buildFinishData(
      finishes: finishes,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = points
        .map(
          (point) => FlSpot(
            point.index.toDouble(),
            point.score,
          ),
        )
        .toList();

    final maxDataY = points
        .map((point) => point.score)
        .reduce((a, b) => a > b ? a : b);

    final yInterval = ChartScale.calculateYInterval(
      0,
      maxDataY,
    );

    final chartMaxY = ChartScale.calculateChartMaxY(
      maxDataY,
      yInterval,
    );

    final xTickOffsets = <double>{};

    if (points.length <= 6) {
      xTickOffsets.addAll(
        points.map((point) => point.index.toDouble()),
      );
    } else {
      final interval = (points.length - 1) / 5;

      for (var i = 0; i < 6; i++) {
        xTickOffsets.add(
          (1 + i * interval).roundToDouble(),
        );
      }
    }

    return StatisticsLineChart(
      spots: spots,
      minX: 1,
      maxX: points.length.toDouble(),
      maxY: chartMaxY,
      xTickOffsets: xTickOffsets,
      yInterval: yInterval,

      bottomTitles: (value, meta) {
        return SideTitleWidget(
          meta: meta,
          child: Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 10),
          ),
        );
      },

      leftTitles: (value, meta) {
        return SideTitleWidget(
          meta: meta,
          child: Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 10),
          ),
        );
      },

      tooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          final pointIndex = spot.spotIndex;

          if (pointIndex < 0 ||
              pointIndex >= points.length) {
            return null;
          }

          final point = points[pointIndex];

          return LineTooltipItem(
            '${ChartAxis.formatTooltipDate(
              point.date,
              // Keine Aggregation: einzelnes Finish
              // wird mit dem konkreten Datum angezeigt.
              StatisticsAggregation.day,
            )}\n'
            'Finish:\n'
            '${point.score.toStringAsFixed(0)} Punkte',
            TextStyle(
              color: settings.finishColor,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList();
      },

      settings: settings,
    );
  }
}