import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/date_filter.dart';
import '../models/default_scores.dart';
import '../models/entry_type.dart';
import '../models/finish_multiplier.dart';
import '../models/new_entry.dart';
import '../models/new_finish_entry.dart';
import '../settings/app_settings.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/entries_chart.dart';
import '../widgets/entry_button.dart';
import '../widgets/entry_summary_card.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({
    super.key,
    required this.entries,
    required this.settings,
    required this.dateFormat,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
    required this.onAddEntry,
    required this.onShowAddDialog,
    required this.onAddHighFinish,
    required this.onDeleteFinish,
    required this.onConfirmDelete,
    required this.onConfirmDeleteFinish,
    required this.finishes,
  });

  final List<NewEntry> entries;
  final AppSettings settings;
  final DateFormat dateFormat;
  final DateFilter selectedDateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;
  final ValueChanged<NewEntry> onAddEntry;
  final Future<void> Function({EntryType? initialType,}) onShowAddDialog;
  final Future<void> Function() onAddHighFinish;
  final Future<void> Function(NewEntry) onConfirmDelete;
  final Future<void> Function(NewFinishEntry) onConfirmDeleteFinish;
  final Future<void> Function(NewFinishEntry) onDeleteFinish;
  final List<NewFinishEntry> finishes;

  int _countEntries({
    required EntryType type,
    int? value,
    bool onlyValidShortLegs = false,
  }) {
    return entries.where((entry) {
      if (entry.type != type) {
        return false;
      }

      if (value != null && entry.value != value) {
        return false;
      }

      if (onlyValidShortLegs &&
          type == EntryType.shortLeg &&
          entry.value > settings.shortLegLimit) {
        return false;
      }

      return true;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final count180 = _countEntries(type: EntryType.score, value: 180);
    final count171 = _countEntries(type: EntryType.score, value: 171);
    final count162 = _countEntries(type: EntryType.score, value: 162);
    final highFinishes = finishes.where((finish) {
      final score = finish.score;
      return score != null && score >= 100;
    }).toList();
    final countSL = _countEntries(
      type: EntryType.shortLeg,
      onlyValidShortLegs: true,
    );
    final highFinishBaseline = selectedDateFilter.includesBaseline
      ? settings.baselineHighFinish
      : 0;

    final shortLegBaseline = selectedDateFilter.includesBaseline
      ? settings.baselineShortLeg
      : 0;

    final history = [
      ...entries.map(_HistoryItem.entry),
      ...finishes
          .where((finish) => finish.score != null && finish.score! >= 100)
          .map(_HistoryItem.finish),
    ]..sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        // date selector
        DateFilterSelector(
          selectedFilter: selectedDateFilter,
          onSelectionChanged: onDateFilterChanged,
        ),
        const SizedBox(height: 8),
        // score buttons
        Row(
          children: defaultScores.map((definition) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: '${definition.score}',
                  color: settings.colorFor(definition.score),
                  onPressed: () => onAddEntry(
                    NewEntry(
                      type: EntryType.score,
                      value: definition.score,
                      timestamp: DateTime.now(),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // score summary cards
        Row(
          children: defaultScores.map((definition) {
            final rawCount = switch (definition.score) {
              180 => count180,
              171 => count171,
              162 => count162,
              _ => 0,
            };
            final baseline = selectedDateFilter.includesBaseline
              ? settings.baselineFor(definition.score)
              : 0;
            final displayCount =
                rawCount + baseline;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: displayCount,
                  color: settings.colorFor(definition.score),
                  label: '${definition.score}',
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // other buttons
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: 'High Finish',
                  color: settings.highFinishColor,
                  onPressed: onAddHighFinish,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: 'Short Leg',
                  color: settings.shortLegColor,
                  onPressed: () => onShowAddDialog(
                    initialType: EntryType.shortLeg,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // other summary cards
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: highFinishes.length + highFinishBaseline,
                  color: settings.highFinishColor,
                  label: 'HF',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: countSL + shortLegBaseline,
                  color: settings.shortLegColor,
                  label: 'SL',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // score chart
        if (entries.isNotEmpty || highFinishes.isNotEmpty) ...[
          EntriesChart(
            entries: entries,
            finishes: highFinishes,
            settings: settings,
            includeBaseline: selectedDateFilter.includesBaseline,
          ),
          const SizedBox(height: 12),
        ],
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Historie',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        if (history.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('Noch keine Treffer erfasst.'),
            ),
          )
        else
          ...history.map<Widget>((item) {
            if (item.value != null) {
              final entry = item.value!;
              final ignored =
                  entry.type == EntryType.shortLeg &&
                  entry.value > settings.shortLegLimit;

              return Card(
                child: ListTile(
                  leading: Icon(entry.type.icon),
                  title: Text(entry.type.format(entry.value)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateFormat.format(entry.timestamp)),
                      if (ignored)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Nicht in der Statistik berücksichtigt\n'
                            '(Statistik-Einstellungen: Grenze für Short Leg '
                            '${settings.shortLegLimit} Darts)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline,
                                ),
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onConfirmDelete(entry),
                    tooltip: 'Löschen',
                  ),
                ),
              );
            }

            final finish = item.finish!;

            final finishLabel = finish.field != null &&
                    finish.multiplier != null
                ? '${finish.multiplier == FinishMultiplier.single ? 'S' : finish.multiplier == FinishMultiplier.double ? 'D' : 'T'}${finish.field}'
                : 'High Finish';

            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.sports_score,
                ),
                title: Text(
                  finish.score != null
                      ? '$finishLabel (${finish.score})'
                      : finishLabel,
                ),
                subtitle: Text(
                  dateFormat.format(finish.timestamp),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onConfirmDeleteFinish(finish),
                  tooltip: 'Löschen',
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _HistoryItem {
  const _HistoryItem.entry(this.value)
      : finish = null;

  const _HistoryItem.finish(this.finish)
      : value = null;

  final NewEntry? value;
  final NewFinishEntry? finish;

  DateTime get timestamp =>
      value?.timestamp ?? finish!.timestamp;
}