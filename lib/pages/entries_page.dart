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

class EntriesPage extends StatefulWidget {
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

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  bool _showAllHistory = false;

  int _countEntries({
    required EntryType type,
    int? value,
    bool onlyValidShortLegs = false,
  }) {
    return widget.entries.where((entry) {
      if (entry.type != type) {
        return false;
      }

      if (value != null && entry.value != value) {
        return false;
      }

      if (onlyValidShortLegs &&
          type == EntryType.shortLeg &&
          entry.value > widget.settings.shortLegLimit) {
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
    final highFinishes = widget.finishes.where((finish) {
      final score = finish.score;
      return score != null && score >= 100;
    }).toList();
    final countSL = _countEntries(
      type: EntryType.shortLeg,
      onlyValidShortLegs: true,
    );
    final highFinishBaseline = widget.selectedDateFilter.includesBaseline
      ? widget.settings.baselineHighFinish
      : 0;

    final shortLegBaseline = widget.selectedDateFilter.includesBaseline
      ? widget.settings.baselineShortLeg
      : 0;

    final history = [
      ...widget.entries.map(_HistoryItem.entry),
      ...widget.finishes
          .where((finish) => finish.score != null && finish.score! >= 100)
          .map(_HistoryItem.finish),
    ]..sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );

    final visibleHistory =
        _showAllHistory ? history : history.take(3).toList();


    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        // date selector
        DateFilterSelector(
          selectedFilter: widget.selectedDateFilter,
          onSelectionChanged: widget.onDateFilterChanged,
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
                  color: widget.settings.colorFor(definition.score),
                  onPressed: () => widget.onAddEntry(
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
            final baseline = widget.selectedDateFilter.includesBaseline
              ? widget.settings.baselineFor(definition.score)
              : 0;
            final displayCount =
                rawCount + baseline;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: displayCount,
                  color: widget.settings.colorFor(definition.score),
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
                  color: widget.settings.highFinishColor,
                  onPressed: widget.onAddHighFinish,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: 'Short Leg',
                  color: widget.settings.shortLegColor,
                  onPressed: () => widget.onShowAddDialog(
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
                  color: widget.settings.highFinishColor,
                  label: 'HF',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: countSL + shortLegBaseline,
                  color: widget.settings.shortLegColor,
                  label: 'SL',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // score chart
        if (widget.entries.isNotEmpty || highFinishes.isNotEmpty) ...[
          EntriesChart(
            entries: widget.entries,
            finishes: highFinishes,
            settings: widget.settings,
            includeBaseline: widget.selectedDateFilter.includesBaseline,
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
        if (visibleHistory.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('Noch keine Treffer erfasst.'),
            ),
          )
        else
          ...visibleHistory.map<Widget>((item) {
            if (item.value != null) {
              final entry = item.value!;
              final ignored =
                  entry.type == EntryType.shortLeg &&
                  entry.value > widget.settings.shortLegLimit;
              return Card(
                child: ListTile(
                  leading: Icon(entry.type.icon),
                  title: Text(entry.type.format(entry.value)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.dateFormat.format(entry.timestamp)),
                      if (ignored)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Nicht in der Statistik berücksichtigt\n'
                            '(Statistik-Einstellungen: Grenze für Short Leg '
                            '${widget.settings.shortLegLimit} Darts)',
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
                    onPressed: () => widget.onConfirmDelete(entry),
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
                  widget.dateFormat.format(finish.timestamp),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => widget.onConfirmDeleteFinish(finish),
                  tooltip: 'Löschen',
                ),
              ),
            );
          }),
          if (history.length > 3) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _showAllHistory = !_showAllHistory;
                });
              },
              child: Text(
                _showAllHistory ? 'Weniger anzeigen' : 'Mehr anzeigen',
              ),
            ),
          ],
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