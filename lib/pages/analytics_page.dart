import 'package:flutter/material.dart';

import '../models/analytics_type.dart';
import '../models/date_filter.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';
import '../widgets/analytics_selector.dart';
import '../widgets/average_finish_chart.dart';
import '../widgets/date_filter_selector.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({
    super.key,
    required this.finishes,
    required this.settings,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
  });

  final List<NewFinishEntry> finishes;
  final AppSettings settings;
  final DateFilter selectedDateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  AnalyticsType _selectedAnalytics = AnalyticsType.averageFinishDart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        AnalyticsSelector(
          selectedAnalytics: _selectedAnalytics,
          onSelectionChanged: (analytics) {
            setState(() {
              _selectedAnalytics = analytics;
            });
          },
        ),

        const SizedBox(height: 8),

        Text(
          _selectedAnalytics.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 16),

        DateFilterSelector(
          selectedFilter: widget.selectedDateFilter,
          onSelectionChanged: widget.onDateFilterChanged,
        ),

        const SizedBox(height: 24),

        if (widget.finishes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('Noch keine Daten vorhanden.'),
            ),
          )
        else
          AverageFinishChart(
            finishes: widget.finishes,
            settings: widget.settings,
          ),
      ],
    );
  }
}