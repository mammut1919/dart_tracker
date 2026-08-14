import 'package:flutter/material.dart';

class PersonalBestsStatistics extends StatelessWidget {
  const PersonalBestsStatistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Finishes'),
        const _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Gewonnene Spiele',
              value: '42',
            ),
            _StatisticRow(
              label: 'Höchstes Finish',
              value: '170',
            ),
            _StatisticRow(
              label: 'High Finishes',
              value: '8',
            ),
            _StatisticRow(
              label: 'Höchster letzter Dart',
              value: 'D20',
            ),
          ],
        ),

        const SizedBox(height: 12),

        const _SectionTitle('Short Legs'),
        const _StatisticsCard(
          rows: [
            _StatisticRow(
              label: 'Kürzestes Short Leg',
              value: '18 Darts',
            ),
            _StatisticRow(
              label: 'Short Legs',
              value: '12',
            ),
          ],
        ),

        const SizedBox(height: 12),

        const _SectionTitle('Scores'),
        const _StatisticsCard(
          rows: [
            _StatisticRow(
              label: '180',
              value: '7',
            ),
            _StatisticRow(
              label: '171',
              value: '4',
            ),
            _StatisticRow(
              label: '162',
              value: '9',
            ),
          ],
        ),
      ],
    );
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