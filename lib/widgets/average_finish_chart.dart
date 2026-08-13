import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../analytics/analytics_builder.dart';
import '../charts/chart_axis.dart';
import '../charts/chart_scale.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';
import '../widgets/statistics_line_chart.dart';

class AverageFinishChart extends StatelessWidget {
  const AverageFinishChart({
    super.key,
    required this.finishes,
    required this.settings,
    required this.aggregation,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;
  final StatisticsAggregation aggregation;

  @override
  Widget build(BuildContext context) {
    final builder = const AnalyticsBuilder();

    final points = builder.buildAverageFinishData(
      finishes: finishes,
      aggregation: aggregation,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstDate = points.first.date;
    final lastDate = points.last.date;

    final xInterval = ChartScale.calculateXInterval(
      lastDate.difference(firstDate).inDays,
    );

    final xTickDates = ChartScale.buildXTickDates(
      firstDate: firstDate,
      lastDate: lastDate,
      interval: xInterval,
    );

    final xTickOffsets = xTickDates
        .map(
          (date) => date
              .difference(firstDate)
              .inDays
              .toDouble(),
        )
        .toSet();

    final spots = <FlSpot>[];

    if (points.length == 1 &&
        aggregation != StatisticsAggregation.day) {
      spots.add(
        FlSpot(0, points.first.average),
      );
      spots.add(
        FlSpot(1, points.first.average),
      );
    } else {
      for (final point in points) {
        final x = point.date
            .difference(firstDate)
            .inDays
            .toDouble();

        spots.add(
          FlSpot(
            x,
            point.average,
          ),
        );
      }
    }

    final maxDataY = points
        .map((point) => point.average)
        .reduce((a, b) => a > b ? a : b);

    final yInterval = ChartScale.calculateYInterval(
      0,
      maxDataY,
    );

    final chartMaxY = ChartScale.calculateChartMaxY(
      maxDataY,
      yInterval,
    );

    return StatisticsLineChart(
      spots: spots,
      maxX: points.length == 1 &&
              aggregation != StatisticsAggregation.day
          ? 1
          : points.last.date
              .difference(points.first.date)
              .inDays
              .toDouble(),
      maxY: chartMaxY,
      xTickOffsets: xTickOffsets,
      yInterval: yInterval,

      bottomTitles: (value, meta) {
        final date = firstDate.add(
          Duration(days: value.round()),
        );

        return SideTitleWidget(
          meta: meta,
          child: Text(
            ChartAxis.formatAggregationDate(
              date,
              aggregation,
            ),
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
          final pointIndex =
              points.length == 1 ? 0 : spot.spotIndex;

          if (pointIndex < 0 ||
              pointIndex >= points.length) {
            return null;
          }

          final point = points[pointIndex];

          return LineTooltipItem(
            '${ChartAxis.formatTooltipDate(
              point.date,
              aggregation,
            )}\n'
            'Ø Finish:\n'
            '${point.average.toStringAsFixed(2)} Punkte',
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