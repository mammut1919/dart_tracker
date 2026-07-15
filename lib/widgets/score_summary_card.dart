import 'package:flutter/material.dart';

class ScoreSummaryCard extends StatelessWidget {
  const ScoreSummaryCard({
    super.key,
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  
            ),
          ],
        ),
      ),
    );
  }
}