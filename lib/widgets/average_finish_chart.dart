import 'package:flutter/material.dart';

import '../models/date_filter.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';

class AverageFinishChart extends StatelessWidget {
  const AverageFinishChart({
    super.key,
    required this.settings,
    required this.selectedDateFilter,
    required this.aggregation,
  });

  final AppSettings settings;
  final DateFilter selectedDateFilter;
  final StatisticsAggregation aggregation;

  static const _chartHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: _chartHeight,
        child: Center(
          child: Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}