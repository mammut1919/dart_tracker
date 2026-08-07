import 'package:flutter/material.dart';

import '../models/analytics_type.dart';

class AnalyticsSelector extends StatelessWidget {
  const AnalyticsSelector({
    super.key,
    required this.selectedAnalytics,
    required this.onSelectionChanged,
  });

  final AnalyticsType selectedAnalytics;
  final ValueChanged<AnalyticsType> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AnalyticsType>(
      tooltip: 'Analyse auswählen',
      onSelected: onSelectionChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AnalyticsType.averageFinishDart,
          child: Row(
            children: [
              if (selectedAnalytics == AnalyticsType.averageFinishDart)
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(AnalyticsType.averageFinishDart.title),
            ],
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedAnalytics.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}