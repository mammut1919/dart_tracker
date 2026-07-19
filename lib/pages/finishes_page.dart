import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/new_finish_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/finish_chart.dart';
import '../widgets/finish_grid.dart';
import '../widgets/finish_multiplier_selector.dart';

class FinishesPage extends StatelessWidget {
  const FinishesPage({
    super.key,
    required this.finishes,
    required this.onSaveFinish,
    required this.onDeleteFinish,
  });

  final List<NewFinishEntry> finishes;

  final Future<void> Function(NewFinishEntry) onSaveFinish;

  final Future<void> Function(NewFinishEntry) onDeleteFinish;

  Future<void> _confirmDeleteFinish(
    BuildContext context,
    NewFinishEntry finish,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Finish löschen?'),
          content: Text(
            'Soll ${finish.field == 50 ? "Bull" : "D${finish.field}"} wirklich gelöscht werden?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await onDeleteFinish(finish);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FinishMultiplierSelector(),
              const SizedBox(height: 12),
              FinishGrid(
                onSelected: (field) {
                  onSaveFinish(
                    NewFinishEntry(field: field, timestamp: DateTime.now()),
                  );
                },
              ),
              const SizedBox(height: 16),
              FinishChart(finishes: finishes),
              const SizedBox(height: 24),
              const Text(
                'Historie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (finishes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Noch keine Finishes erfasst.')),
                )
              else
                ...finishes.map<Widget>((finish) {
                  return Dismissible(
                    key: ValueKey(finish.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      await _confirmDeleteFinish(context, finish);
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
                        onLongPress: () =>
                            _confirmDeleteFinish(context, finish),
                        leading: const Icon(Icons.gps_fixed),
                        title: Text(
                          finish.field == 50 ? 'Bull' : 'D${finish.field}',
                        ),
                        subtitle: Text(
                          DateFormat('dd.MM.yyyy').format(finish.timestamp),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
