import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../settings/app_settings.dart';

class StatisticsLineChart extends StatelessWidget {
  const StatisticsLineChart({
    super.key,
    required this.spots,
    this.minX = 0,
    required this.maxX,
    required this.maxY,
    required this.xTickOffsets,
    required this.yInterval,
    required this.bottomTitles,
    required this.leftTitles,
    required this.tooltipItems,
    required this.settings,
  });

  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double maxY;
  final Set<double> xTickOffsets;
  final double yInterval;

  final Widget Function(double value, TitleMeta meta) bottomTitles;
  final Widget Function(double value, TitleMeta meta) leftTitles;

  final List<LineTooltipItem?> Function(
    List<LineBarSpot> touchedSpots,
  ) tooltipItems;

  final AppSettings settings;

  static const _chartHeight = 250.0;
  static const _padding = 16.0;
  static const _axisReservedSize = 34.0;
  static const _lineWidth = 3.0;
  static const _animationDuration =
      Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: _chartHeight,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
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
                      final x = value.round().toDouble();

                      if (!xTickOffsets.contains(x)) {
                        return const SizedBox.shrink();
                      }

                      return bottomTitles(value, meta);
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: _axisReservedSize,
                    interval: yInterval,
                    getTitlesWidget: leftTitles,
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  getTooltipItems: tooltipItems,
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