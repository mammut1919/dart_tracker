import 'package:flutter/material.dart';

import '../models/statistics_aggregation.dart';

class StatisticsAggregationSelector extends StatelessWidget {
  const StatisticsAggregationSelector({
    super.key,
    required this.selectedAggregation,
    required this.onSelectionChanged,
  });

  final StatisticsAggregation selectedAggregation;
  final ValueChanged<StatisticsAggregation> onSelectionChanged;

  String _label(StatisticsAggregation aggregation) {
    switch (aggregation) {
      case StatisticsAggregation.day:
        return 'Pro Tag';
      case StatisticsAggregation.week:
        return 'Pro Woche';
      case StatisticsAggregation.month:
        return 'Pro Monat';
      case StatisticsAggregation.year:
        return 'Pro Jahr';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<StatisticsAggregation>(
      initialValue: selectedAggregation,
      onSelected: onSelectionChanged,
      itemBuilder: (context) {
        return StatisticsAggregation.values.map((aggregation) {
          return PopupMenuItem<StatisticsAggregation>(
            value: aggregation,
            child: Text(_label(aggregation)),
          );
        }).toList();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_label(selectedAggregation)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}