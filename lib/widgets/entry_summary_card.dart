import 'package:flutter/material.dart';

class EntrySummaryCard extends StatelessWidget {
  const EntrySummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        child: Column(
          children: [
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
