import 'package:flutter/material.dart';

import '../analytics/analytics_builder.dart';
import '../models/analytics_type.dart';
import '../models/date_filter.dart';
import '../models/new_entry.dart';
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
import '../widgets/personal_bests_statistics.dart';
import '../widgets/statistics_aggregation_selector.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({
    super.key,
    required this.entries,
    required this.finishes,
    required this.settings,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
    required this.selectedAnalytics,
    required this.onAnalyticsChanged,
  });

  final List<NewEntry> entries;
  final List<NewFinishEntry> finishes;

  final AppSettings settings;
  final DateFilter selectedDateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;
  final AnalyticsType selectedAnalytics;
  final ValueChanged<AnalyticsType> onAnalyticsChanged;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  StatisticsAggregation _selectedAggregation = StatisticsAggregation.day;

  @override
  Widget build(BuildContext context) {
    final builder = const AnalyticsBuilder();

    final personalBests = builder.buildPersonalBests(
      entries: widget.entries,
      finishes: widget.finishes,
      settings: widget.settings,
      selectedDateFilter: widget.selectedDateFilter,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        AnalyticsSelector(
          selectedAnalytics: widget.selectedAnalytics,
          onSelectionChanged: widget.onAnalyticsChanged,
        ),

        const SizedBox(height: 8),

        Text(
          widget.selectedAnalytics.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            DateFilterSelector(
              selectedFilter: widget.selectedDateFilter,
              onSelectionChanged: widget.onDateFilterChanged,
              showToday: widget.selectedAnalytics != AnalyticsType.activity,
            ),

            const Spacer(),

            if (widget.selectedAnalytics == AnalyticsType.averageFinish ||
                widget.selectedAnalytics == AnalyticsType.averageFinishDart ||
                widget.selectedAnalytics == AnalyticsType.activity)
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
            child: Center(child: Text('Noch keine Daten vorhanden.')),
          )
        else if (widget.selectedAnalytics == AnalyticsType.personalBests) ...[
          PersonalBestsStatistics(personalBests: personalBests),
        ],

        if (widget.selectedAnalytics == AnalyticsType.finishes) ...[
          FinishesChart(finishes: widget.finishes, settings: widget.settings),

          const SizedBox(height: 16),

          FinishesStatistics(finishes: widget.finishes),
        ],

        if (widget.selectedAnalytics == AnalyticsType.averageFinish) ...[
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

        if (widget.selectedAnalytics == AnalyticsType.averageFinishDart) ...[
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

        if (widget.selectedAnalytics == AnalyticsType.activity) ...[
          ActivityChart(
            finishes: widget.finishes,
            settings: widget.settings,
            selectedDateFilter: widget.selectedDateFilter,
            aggregation: _selectedAggregation,
          ),

          const SizedBox(height: 16),

          ActivityStatistics(finishes: widget.finishes),
        ],
      ],
    );
  }
}
