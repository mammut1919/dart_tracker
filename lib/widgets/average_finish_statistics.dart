import 'package:flutter/material.dart';

import '../analytics/analytics_builder.dart';
import '../models/finish_multiplier.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';

class AverageFinishStatistics extends StatelessWidget {
  const AverageFinishStatistics({
    super.key,
    required this.finishes,
    required this.aggregation,
  });

  final List<NewFinishEntry> finishes;
  final StatisticsAggregation aggregation;

  @override
  Widget build(BuildContext context) {
    if (finishes.isEmpty) {
      return const SizedBox.shrink();
    }

    final builder = const AnalyticsBuilder();

    final points = builder.buildAverageFinishData(
      finishes: finishes,
      aggregation: aggregation,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentAverage = points.last.average;

    final bestAverage = points
        .map((point) => point.average)
        .reduce((a, b) => a > b ? a : b);

    final totalScore = finishes.fold<double>(
      0,
      (sum, finish) =>
          sum + finish.field * finish.multiplier.factor,
    );

    final periodAverage = totalScore / finishes.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatisticRow(
              label: 'Aktueller Durchschnitt',
              value: currentAverage.toStringAsFixed(2),
            ),
            const Divider(),
            _StatisticRow(
              label: 'Höchster Durchschnitt',
              value: bestAverage.toStringAsFixed(2),
            ),
            const Divider(),
            _StatisticRow(
              label: 'Durchschnitt Zeitraum',
              value: periodAverage.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}