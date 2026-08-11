import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../analytics/activity_builder.dart';
import '../charts/chart_axis.dart';
import '../charts/chart_scale.dart';
import '../models/date_filter.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';
import '../widgets/statistics_line_chart.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({
    super.key,
    required this.finishes,
    required this.settings,
    required this.selectedDateFilter,
    required this.aggregation,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;
  final DateFilter selectedDateFilter;
  final StatisticsAggregation aggregation;

  @override
  Widget build(BuildContext context) {
    final builder = const ActivityBuilder();

    final points = builder.buildActivityData(
      finishes: finishes,
      startDate: selectedDateFilter.startDate,
      aggregation: aggregation,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = <FlSpot>[];

    if (points.length == 1 && aggregation != StatisticsAggregation.day) {
      spots.add(
        FlSpot(0, points.first.finishes.toDouble()),
      );
      spots.add(
        FlSpot(1, points.first.finishes.toDouble()),
      );
    } else {
      for (var i = 0; i < points.length; i++) {
        final point = points[i];

        spots.add(
          FlSpot(
            i.toDouble(),
            point.finishes.toDouble(),
          ),
        );
      }
    }

    final maxDataY = points
        .map((point) => point.finishes)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

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
          : (points.length - 1).toDouble(),
      maxY: chartMaxY,
      yInterval: yInterval,
      bottomTitles: (value, meta) {
        final index = value.round();

        if (index < 0 || index >= points.length) {
          return const SizedBox.shrink();
        }

        final current = points[index].date;

        if (!ChartAxis.shouldShowLabel(
          index: index,
          pointCount: points.length,
          filter: selectedDateFilter,
        )) {
          return const SizedBox.shrink();
        }

        return SideTitleWidget(
          meta: meta,
          child: Text(
            ChartAxis.formatDate(
              current,
              selectedDateFilter,
              firstDate: points.first.date,
              lastDate: points.last.date,
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
          ),
        );
      },
      tooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          final pointIndex = points.length == 1
              ? 0
              : spot.spotIndex;

          if (pointIndex < 0 || pointIndex >= points.length) {
            return null;
          }

          final point = points[pointIndex];

          return LineTooltipItem(
            '${ChartAxis.formatTooltipDate(point.date, aggregation)}\n'
            '${point.finishes} Finishes',
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
