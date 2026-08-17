import 'package:flutter/material.dart';

import '../models/finish_multiplier.dart';
import '../models/new_finish_entry.dart';
import '../models/personal_bests.dart';

class PersonalBestsStatistics extends StatelessWidget {
  const PersonalBestsStatistics({
    super.key,
    required this.personalBests,
  });

  final PersonalBests personalBests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Scores'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: '180er',
              value: '${personalBests.count180}',
            ),
            _StatisticRow(
              label: '171er',
              value: '${personalBests.count171}',
            ),
            _StatisticRow(
              label: '162er',
              value: '${personalBests.count162}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Finishes'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Anzahl Finishes',
              value: '${personalBests.finishCount}',
            ),
            _StatisticRow(
              label: 'High Finishes',
              value: '${personalBests.highFinishCount}',
            ),
            _StatisticRow(
              label: 'Höchstes Finish',
              value: '${personalBests.highestFinish ?? '-'}',
            ),
            _StatisticRow(
              label: 'Höchster Checkout-Dart',
              value: personalBests.highestLastDart == null
                  ? '-'
                  : _formatFinishField(
                      personalBests.highestLastDart!,
                    )!,
            ),
            _StatisticRow(
              label: 'Häufigstes Finish-Feld',
              value: _formatMostFrequentFields(),
              onTap: personalBests.mostFrequentFinishFields.length > 3
                  ? () => _showFrequentValuesDialog(
                      context,
                      title: 'Häufigstes Finish-Feld',
                      values: personalBests.mostFrequentFinishFields,
                      count: personalBests.mostFrequentFinishFieldCount!,
                    )
                  : null,
            ),
            _StatisticRow(
              label: 'Häufigstes Finish',
              value: _formatMostFrequentFinishes(),
              onTap: personalBests.mostFrequentFinishes.length > 3
                  ? () => _showFrequentValuesDialog(
                      context,
                      title: 'Häufigstes Finish',
                      values: personalBests.mostFrequentFinishes
                          .map((value) => value.toString())
                          .toList(),
                      count: personalBests.mostFrequentFinishCount!,
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Short Legs'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Kürzestes Short Leg',
              value: personalBests.shortestShortLeg == null
                  ? '-'
                  : '${personalBests.shortestShortLeg} Darts',
            ),
            _StatisticRow(
              label: 'Short Legs',
              value: '${personalBests.shortLegCount}',
            ),
          ],
        ),
      ],
    );
  }

  String _formatMostFrequentFields() {
    final values = personalBests.mostFrequentFinishFields;
    final count = personalBests.mostFrequentFinishFieldCount;

    if (values.isEmpty || count == null) {
      return '-';
    }

    if (values.length <= 3) {
      return '${values.join(', ')} ($count×)';
    }

    return '${values.first} +${values.length - 1} weitere (je $count×)';
  }

  String _formatMostFrequentFinishes() {
    final values = personalBests.mostFrequentFinishes;
    final count = personalBests.mostFrequentFinishCount;

    if (values.isEmpty || count == null) {
      return '-';
    }

    if (values.length <= 3) {
      return '${values.join(', ')} ($count×)';
    }

    return '${values.first} +${values.length - 1} weitere (je $count×)';
  }

  void _showFrequentValuesDialog(
    BuildContext context, {
    required String title,
    required List<String> values,
    required int count,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => _FrequentValuesDialog(
        title: title,
        values: values,
        count: count,
      ),
    );
  }

  String? _formatFinishField(NewFinishEntry finish) {
    if (finish.field == null || finish.multiplier == null) {
      return null;
    }

    if (finish.field == 25) {
      return 'Bull';
    }

    switch (finish.multiplier!) {
      case FinishMultiplier.single:
        return 'S${finish.field}';

      case FinishMultiplier.double:
        return 'D${finish.field}';

      case FinishMultiplier.triple:
        return 'T${finish.field}';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 6,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.rows,
  });

  final List<_StatisticRow> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              rows[i],
              if (i < rows.length - 1)
                const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}

class _FrequentValuesDialog extends StatelessWidget {
  const _FrequentValuesDialog({
    required this.title,
    required this.values,
    required this.count,
  });

  final String title;
  final List<String> values;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final value in values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(value),
                  ),
                  Text(
                    '$count×',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}