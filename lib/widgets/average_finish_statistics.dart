import 'package:flutter/material.dart';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatisticRow(
              label: 'Aktueller Durchschnitt',
              value: '—',
            ),
            const Divider(),
            _StatisticRow(
              label: 'Höchster Durchschnitt',
              value: '—',
            ),
            const Divider(),
            _StatisticRow(
              label: 'Durchschnitt Zeitraum',
              value: '—',
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