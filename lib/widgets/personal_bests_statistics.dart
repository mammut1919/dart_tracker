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
        const _SectionTitle('Finishes'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Anzahl Finishes',
              value: '${personalBests.finishCount}',
            ),
            _StatisticRow(
              label: 'Höchstes Finish',
              value: '${personalBests.highestFinish ?? '-'}',
            ),
            _StatisticRow(
              label: 'High Finishes',
              value: '${personalBests.highFinishCount}',
            ),
            _StatisticRow(
              label: 'Höchster letzter Dart',
              value: personalBests.highestLastDart == null
                  ? '-'
                  : _formatFinishField(
                      personalBests.highestLastDart!,
                    )!,
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

        const SizedBox(height: 12),

        const _SectionTitle('Scores'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: '180',
              value: '${personalBests.count180}',
            ),
            _StatisticRow(
              label: '171',
              value: '${personalBests.count171}',
            ),
            _StatisticRow(
              label: '162',
              value: '${personalBests.count162}',
            ),
          ],
        ),

        const SizedBox(height: 12),

        const _SectionTitle('Häufigste Finishes'),
        _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Häufigstes Finish-Feld',
              value: _formatMostFrequentFields(),
            ),
            _StatisticRow(
              label: 'Häufigstes Finish',
              value: _formatMostFrequentFinishes(),
            ),
          ],
        ),
      ],
    );
  }

  String _formatMostFrequentFields() {
    if (personalBests.mostFrequentFinishFields.isEmpty ||
        personalBests.mostFrequentFinishFieldCount == null) {
      return '-';
    }

    return '${personalBests.mostFrequentFinishFields.join(', ')} '
        '(${personalBests.mostFrequentFinishFieldCount}×)';
  }

  String _formatMostFrequentFinishes() {
    if (personalBests.mostFrequentFinishes.isEmpty ||
        personalBests.mostFrequentFinishCount == null) {
      return '-';
    }

    return '${personalBests.mostFrequentFinishes.join(', ')} '
        '(${personalBests.mostFrequentFinishCount}×)';
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
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}