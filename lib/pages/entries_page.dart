import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/default_scores.dart';
import '../models/entry_option.dart';
import '../models/entry_options.dart';
import '../models/entry_type.dart';
import '../models/new_entry.dart';
import '../settings/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/entry_button.dart';
import '../widgets/entry_summary_card.dart';
import '../widgets/score_chart.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({
    super.key,
    required this.entries,
    required this.settings,
    required this.dateFormat,
    required this.onAddEntry,
    required this.onShowAddDialog,
    required this.onConfirmDelete,
  });

  final List<NewEntry> entries;
  final AppSettings settings;
  final DateFormat dateFormat;
  final ValueChanged<NewEntry> onAddEntry;
  final Future<void> Function({EntryOption? initialOption}) onShowAddDialog;
  final Future<void> Function(NewEntry) onConfirmDelete;

  int _countEntries({required EntryType type, int? value}) {
    return entries.where((entry) {
      if (entry.type != type) {
        return false;
      }

      return value == null || entry.value == value;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final count180 = _countEntries(type: EntryType.score, value: 180);
    final count171 = _countEntries(type: EntryType.score, value: 171);
    final count162 = _countEntries(type: EntryType.score, value: 162);
    final countHF = _countEntries(type: EntryType.highFinish);

    final countSL = _countEntries(type: EntryType.shortLeg);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // score buttons
        Row(
          children: defaultScores.map((definition) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: '${definition.score}',
                  color: definition.color,
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
            final displayCount =
                rawCount + settings.baselineFor(definition.score);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: displayCount,
                  color: definition.color,
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
                  color: AppColors.highFinish,
                  onPressed: () =>
                      onShowAddDialog(initialOption: highFinishOption),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntryButton(
                  label: 'Short Leg',
                  color: AppColors.shortLeg,
                  onPressed: () =>
                      onShowAddDialog(initialOption: shortLegOption),
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
                  count: countHF + settings.baselineHighFinish,
                  color: AppColors.highFinish,
                  label: 'HF',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: EntrySummaryCard(
                  count: countSL + settings.baselineShortLeg,
                  color: AppColors.shortLeg,
                  label: 'SL',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // score chart
        if (entries.isNotEmpty) ...[
          ScoreChart(entries: entries, settings: settings),
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 24),
        // history
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Historie',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        // list of historic scores
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Noch keine Treffer erfasst.')),
          )
        else
          ...entries.map<Widget>((entry) {
            return Dismissible(
              key: ValueKey(entry.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) async {
                await onConfirmDelete(entry);
                return false;
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                color: AppColors.delete,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                child: ListTile(
                  onLongPress: () => onConfirmDelete(entry),
                  leading: Icon(entry.type.icon),
                  title: Text(entry.type.format(entry.value)),
                  subtitle: Text(dateFormat.format(entry.timestamp)),
                ),
              ),
            );
          }),
      ],
    );
  }
}
