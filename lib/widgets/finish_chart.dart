import 'package:flutter/material.dart';

import '../models/finish_multiplier.dart';
import '../models/finish_fields.dart';
import '../models/new_finish_entry.dart';

class FinishChart extends StatelessWidget {
  FinishChart({
    super.key,
    required this.finishes,
  });

  final List<NewFinishEntry> finishes;

  final finishOrder = [...finishFields]
    ..sort((a, b) => b.compareTo(a));

  Map<int, int> _buildCounts() {
    final counts = <int, int>{};

    // Alle Felder mit 0 initialisieren
    for (final field in finishFields) {
      counts[field] = 0;
    }

    // Treffer zählen
    for (final finish in finishes) {
      counts.update(
        finish.field,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return counts;
  }


  int _maxCount(Map<int, int> counts) {
    return counts.values.fold(0, (max, value) {
      return value > max ? value : max;
    });
  }

  @override
  Widget build(BuildContext context) {
    final counts = _buildCounts();
    final maxCount = _maxCount(counts);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: finishOrder.map((field) {
            final count = counts[field]!;
            final factor = maxCount == 0 ? 0.0 : count / maxCount;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      finishChartLabel(field, FinishMultiplier.double),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 14,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey.shade300,
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: factor,
                              child: Container(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 28,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}