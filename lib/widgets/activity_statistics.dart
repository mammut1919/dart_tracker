import 'package:flutter/material.dart';

import '../analytics/activity_builder.dart';
import '../models/new_finish_entry.dart';

class ActivityStatistics extends StatelessWidget {
  const ActivityStatistics({
    super.key,
    required this.finishes,
  });

  final List<NewFinishEntry> finishes;

  @override
  Widget build(BuildContext context) {
    final builder = const ActivityBuilder();

    final points = builder.buildActivityData(
      finishes: finishes,
    );

    final trainingDays = points.where((point) => point.finishes > 0).length;

    var currentSeries = 0;
    var bestSeries = 0;
    var runningSeries = 0;

    for (final point in points) {
      if (point.finishes > 0) {
        runningSeries++;

        if (runningSeries > bestSeries) {
          bestSeries = runningSeries;
        }
      } else {
        runningSeries = 0;
      }
    }

    for (var i = points.length - 1; i >= 0; i--) {
      if (points[i].finishes > 0) {
        currentSeries++;
      } else {
        break;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatisticRow(
              label: 'Aktuelle Serie',
              value: '$currentSeries Tage',
            ),
            const Divider(),
            _StatisticRow(
              label: 'Beste Serie',
              value: '$bestSeries Tage',
            ),
            const Divider(),
            _StatisticRow(
              label: 'Trainingstage',
              value: '$trainingDays',
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