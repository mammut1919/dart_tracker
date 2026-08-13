import 'package:flutter/material.dart';

import '../analytics/analytics_builder.dart';
import '../models/new_finish_entry.dart';

class FinishesStatistics extends StatelessWidget {
  const FinishesStatistics({
    super.key,
    required this.finishes,
  });

  final List<NewFinishEntry> finishes;

  @override
  Widget build(BuildContext context) {
    final builder = const AnalyticsBuilder();

    final points = builder.buildFinishData(
      finishes: finishes,
    );

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final topFinishes = [...points]
      ..sort(
        (a, b) => b.score.compareTo(a.score),
      );

    final top3 = topFinishes.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (top3.isNotEmpty)
              _StatisticRow(
                label: 'Höchstes Finish',
                value: top3[0].score.toStringAsFixed(0),
              ),
            if (top3.length > 1) ...[
              const Divider(),
              _StatisticRow(
                label: 'Zweithöchstes Finish',
                value: top3[1].score.toStringAsFixed(0),
              ),
            ],
            if (top3.length > 2) ...[
              const Divider(),
              _StatisticRow(
                label: 'Dritthöchstes Finish',
                value: top3[2].score.toStringAsFixed(0),
              ),
            ],
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