import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../analytics/activity_builder.dart';
import '../charts/chart_axis.dart';
import '../charts/chart_constants.dart';
import '../charts/chart_scale.dart';
import '../models/date_filter.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({
    super.key,
    required this.finishes,
    required this.settings,
    required this.selectedDateFilter,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;
  final DateFilter selectedDateFilter;

  static const _chartHeight = 250.0;
  static const _padding = 16.0;
  static const _axisReservedSize = 34.0;
  static const _lineWidth = 3.0;
  static const _animationDuration =
      Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final builder = const ActivityBuilder();

    final points = builder.buildActivityData(
      finishes: finishes,
      startDate: selectedDateFilter.startDate,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = <FlSpot>[];

    for (var i = 0; i < points.length; i++) {
      final point = points[i];

      spots.add(
        FlSpot(
          i.toDouble(),
          point.finishes.toDouble(),
        ),
      );
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

    return Card(
      child: SizedBox(
        height: _chartHeight,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (points.length - 1).toDouble(),
              minY: 0,
              maxY: chartMaxY,

              borderData: FlBorderData(show: true),

              gridData: FlGridData(show: true),

              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: _axisReservedSize,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();

                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }

                      final current = points[index].date;

/* vorübergehend deaktiviert
                      if (!ChartAxis.shouldShowLabel(
                        index: index,
                        date: points[index].date,
                        filter: selectedDateFilter,
                      )) {
                        return const SizedBox.shrink();
                      }
*/
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          ChartAxis.formatDate(
                            current,
                            selectedDateFilter,
                          ),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: ChartConstants.axisReservedSize,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toInt().toString(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final point = points[spot.spotIndex];

                      return LineTooltipItem(
                        '${DateFormat('dd.MM.yyyy').format(point.date)}\n'
                        '${point.finishes} Finishes',
                        TextStyle(
                          color: settings.finishColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: settings.finishColor,
                  barWidth: _lineWidth,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}