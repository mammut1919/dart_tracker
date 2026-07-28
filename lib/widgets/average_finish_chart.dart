import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../analytics/analytics_builder.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';

class AverageFinishChart extends StatelessWidget {
  const AverageFinishChart({
    super.key,
    required this.finishes,
    required this.settings,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;

  static const _chartHeight = 250.0;
  static const _padding = 16.0;
  static const _axisReservedSize = 34.0;
  static const _lineWidth = 3.0;
  static const _animationDuration =
      Duration(milliseconds: 350);

  double _calculateXInterval(int count) {
    if (count <= 4) return 1;
    if (count <= 10) return 2;
    if (count <= 20) return 5;
    if (count <= 60) return 10;
    if (count <= 120) return 20;

    return 30;
  }

  @override
  Widget build(BuildContext context) {
    final builder = const AnalyticsBuilder();

    final points = builder.buildAverageFinishData(
      finishes: finishes,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = <FlSpot>[];

    for (var i = 0; i < points.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          points[i].average,
        ),
      );
    }

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
              maxY: 60,

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
                    interval: _calculateXInterval(points.length),
                    getTitlesWidget: (value, meta) {
                      final index = value.round();

                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          DateFormat('dd.MM').format(points[index].date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: _axisReservedSize,
                    interval: 10,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
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
                        'Ø letzter Dart:\n'
                        '${point.average.toStringAsFixed(2)} Punkte',
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