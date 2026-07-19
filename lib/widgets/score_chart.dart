import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../settings/app_settings.dart';
import '../charts/chart_builder.dart';
import '../charts/chart_data.dart';
import '../charts/chart_range.dart';
import '../charts/chart_series.dart';
import '../models/default_scores.dart';
import '../models/entry_type.dart';
import '../models/new_entry.dart';
import '../theme/app_colors.dart';

class ScoreChart extends StatelessWidget {
  const ScoreChart({super.key, required this.entries, required this.settings});

  static const _chartHeight = 250.0;
  static const _padding = 16.0;
  static const _axisReservedSize = 34.0;
  static const _lineWidth = 3.0;
  static const _animationDuration = Duration(milliseconds: 350);

  final List<NewEntry> entries;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final builder = const ChartBuilder();

    final range = ChartRange.fromEntries(entries);

    final series = _buildSeries(builder, range);

    final lines = series
        .map((s) => _buildLine(chart: s.chart, color: s.color))
        .toList();

    final maxDataY = _calculateMaxDataY(lines);

    final minY = _calculateMinY(settings);

    final yInterval = _calculateYInterval(minY, maxDataY);

    final chartMaxY = _calculateChartMaxY(maxDataY, yInterval);

    return Card(
      child: SizedBox(
        height: _chartHeight,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: LineChart(
            _buildChartData(
              series,
              lines,
              range,
              minY,
              maxDataY,
              yInterval,
              chartMaxY,
            ),
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }

  LineChartData _buildChartData(
    List<ChartSeries> series,
    List<LineChartBarData> lines,
    ChartRange range,
    double minY,
    double maxY,
    double yInterval,
    double chartMaxY,
  ) {
    final xInterval = _calculateXInterval(range);

    return LineChartData(
      lineBarsData: lines,

      minX: 0,
      maxX: range.maxX,
      minY: minY,
      maxY: chartMaxY,

      gridData: FlGridData(
        show: true,

        drawHorizontalLine: true,
        drawVerticalLine: true,

        horizontalInterval: yInterval,
        verticalInterval: xInterval,

        checkToShowHorizontalLine: (_) => true,

        checkToShowVerticalLine: (value) {
          final remainder = value % xInterval;
          return remainder.abs() < 0.1 || (xInterval - remainder).abs() < 0.1;
        },
      ),

      borderData: FlBorderData(show: true),

      titlesData: _buildTitlesData(range, xInterval, yInterval, chartMaxY),

      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.tooltipBackground,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final currentSeries = series[spot.barIndex];
              final date = range.dateAt(spot.x);

              var value = spot.y.toInt();

              final points = currentSeries.chart.points;

              if (spot.spotIndex + 1 < points.length) {
                final next = points[spot.spotIndex + 1];

                const epsilon = 0.001;

                if ((next.x - spot.x).abs() < epsilon && next.y > spot.y) {
                  value = next.y.toInt();
                }
              }

              return LineTooltipItem(
                '${DateFormat('dd.MM.yyyy').format(date)}\n'
                '${currentSeries.label} ($value)',
                TextStyle(
                  color: currentSeries.color,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData(
    ChartRange range,
    double xInterval,
    double yInterval,
    double chartMaxY,
  ) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _axisReservedSize,
          interval: yInterval,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              meta: meta,
              child: Text(value.toInt().toString()),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _axisReservedSize,
          interval: xInterval,
          getTitlesWidget: (value, meta) {
            if (value >= range.maxX - xInterval / 2) {
              return const SizedBox.shrink();
            }

            final date = range.dateAt(value);

            return SideTitleWidget(
              meta: meta,
              child: Text(
                DateFormat('dd.MM').format(date),
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
    );
  }

  LineChartBarData _buildLine({
    required ChartData chart,
    required Color color,
  }) {
    return LineChartBarData(
      spots: chart.points.map((point) => point.spot).toList(),
      isCurved: false,
      isStrokeCapRound: true,
      color: color,
      barWidth: _lineWidth,
      dotData: const FlDotData(show: false),
    );
  }

  List<ChartSeries> _buildSeries(ChartBuilder builder, ChartRange range) {
    final series = defaultScores.map((definition) {
      final chart = builder.buildStepChart(
        entries: entries,
        type: EntryType.score,
        value: definition.score,
        baseline: settings.baselineFor(definition.score),
        chartStart: range.firstDate,
        chartEnd: range.lastDate,
      );

      return ChartSeries(
        label: '${definition.score}',
        color: definition.color,
        chart: chart,
      );
    }).toList();

    final highFinishChart = builder.buildStepChart(
      entries: entries,
      type: EntryType.highFinish,
      baseline: settings.baselineHighFinish,
      chartStart: range.firstDate,
      chartEnd: range.lastDate,
    );

    series.add(
      ChartSeries(
        label: 'High Finish',
        color: AppColors.highFinish,
        chart: highFinishChart,
      ),
    );

    final shortLegChart = builder.buildStepChart(
      entries: entries,
      type: EntryType.shortLeg,
      baseline: settings.baselineShortLeg,
      chartStart: range.firstDate,
      chartEnd: range.lastDate,
    );

    series.add(
      ChartSeries(
        label: 'Short Leg',
        color: AppColors.shortLeg,
        chart: shortLegChart,
      ),
    );

    return series;
  }

  double _calculateMaxDataY(List<LineChartBarData> chartLines) {
    double maxDataY = 0;

    for (final line in chartLines) {
      for (final spot in line.spots) {
        if (spot.y > maxDataY) {
          maxDataY = spot.y;
        }
      }
    }

    return maxDataY;
  }

  double _calculateMinY(AppSettings settings) {
    final lowestBaseline = [
      settings.baseline180,
      settings.baseline171,
      settings.baseline162,
      settings.baselineHighFinish,
      settings.baselineShortLeg,
    ].reduce((a, b) => a < b ? a : b);

    return lowestBaseline == 0 ? 0.0 : (lowestBaseline - 1).toDouble();
  }

  double _calculateYInterval(double minY, double maxY) {
    final range = maxY - minY;

    if (range <= 10) return 1;
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 200) return 20;

    return 50;
  }

  double _calculateChartMaxY(double maxValue, double interval) {
    return ((maxValue + 1) / interval).ceil() * interval;
  }

  double _calculateXInterval(ChartRange range) {
    final days = range.maxX.round();

    if (days <= 4) return 1;
    if (days <= 10) return 2;
    if (days <= 20) return 5;
    if (days <= 60) return 10;
    if (days <= 120) return 20;

    return 30;
  }
}
