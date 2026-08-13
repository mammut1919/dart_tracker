import 'package:flutter/material.dart';

import '../models/analytics_type.dart';
import '../models/date_filter.dart';
import '../models/new_finish_entry.dart';
import '../models/statistics_aggregation.dart';
import '../settings/app_settings.dart';
import '../widgets/activity_chart.dart';
import '../widgets/activity_statistics.dart';
import '../widgets/analytics_selector.dart';
import '../widgets/average_finish_chart.dart';
import '../widgets/average_finish_statistics.dart';
import '../widgets/average_last_dart_chart.dart';
import '../widgets/average_last_dart_statistics.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/finishes_chart.dart';
import '../widgets/finishes_statistics.dart';
import '../widgets/statistics_aggregation_selector.dart';

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
  AnalyticsType _selectedAnalytics = AnalyticsType.finishes;

  StatisticsAggregation _selectedAggregation = StatisticsAggregation.day;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        AnalyticsSelector(
          selectedAnalytics: _selectedAnalytics,
          onSelectionChanged: (analytics) {
            if (analytics == AnalyticsType.activity &&
                widget.selectedDateFilter == DateFilter.today) {
              widget.onDateFilterChanged(DateFilter.last7Days);
            }

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

        Row(
          children: [
            DateFilterSelector(
              selectedFilter: widget.selectedDateFilter,
              onSelectionChanged: widget.onDateFilterChanged,
              showToday: _selectedAnalytics != AnalyticsType.activity,
            ),

            const Spacer(),

            if (_selectedAnalytics != AnalyticsType.finishes)
              StatisticsAggregationSelector(
                selectedAggregation: _selectedAggregation,
                onSelectionChanged: (aggregation) {
                  setState(() {
                    _selectedAggregation = aggregation;
                  });
                },
              ),
          ],
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
          if (_selectedAnalytics == AnalyticsType.finishes) ...[
            FinishesChart(
              finishes: widget.finishes,
              settings: widget.settings,
            ),

            const SizedBox(height: 16),

            FinishesStatistics(
              finishes: widget.finishes,
            ),
          ],

          if (_selectedAnalytics == AnalyticsType.averageFinish) ...[
            AverageFinishChart(
              finishes: widget.finishes,
              settings: widget.settings,
              aggregation: _selectedAggregation,
            ),

            const SizedBox(height: 16),

            AverageFinishStatistics(
              finishes: widget.finishes,
              aggregation: _selectedAggregation,
            ),
          ],

          if (_selectedAnalytics == AnalyticsType.averageFinishDart) ...[
            AverageLastDartChart(
              finishes: widget.finishes,
              settings: widget.settings,
              aggregation: _selectedAggregation,
            ),

            const SizedBox(height: 16),

            AverageLastDartStatistics(
              finishes: widget.finishes,
              aggregation: _selectedAggregation,
            ),
          ],

          if (_selectedAnalytics == AnalyticsType.activity) ...[
            ActivityChart(
              finishes: widget.finishes,
              settings: widget.settings,
              selectedDateFilter: widget.selectedDateFilter,
              aggregation: _selectedAggregation,
            ),

            const SizedBox(height: 16),

            ActivityStatistics(
              finishes: widget.finishes,
            ),
          ],
      ],
    );
  }
}
