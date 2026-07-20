import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/date_filter.dart';
import '../models/finish_multiplier.dart';
import '../models/new_finish_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/finish_chart.dart';
import '../widgets/finish_grid.dart';
import '../widgets/finish_multiplier_selector.dart';

class FinishesPage extends StatefulWidget {
  const FinishesPage({
    super.key,
    required this.finishes,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
    required this.onSaveFinish,
    required this.onDeleteFinish,
  });

  final List<NewFinishEntry> finishes;
  final DateFilter selectedDateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;
  final Future<void> Function(NewFinishEntry) onSaveFinish;
  final Future<void> Function(NewFinishEntry) onDeleteFinish;

  @override
  State<FinishesPage> createState() => _FinishesPageState();
}

class _FinishesPageState extends State<FinishesPage> {
  FinishMultiplier _selectedMultiplier = FinishMultiplier.double;

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
            'Soll ${
              finish.field == 50
                ? "Bull"
                : "${finish.multiplier == FinishMultiplier.double ? 'D' : 'T'}${finish.field}"
            } wirklich gelöscht werden?',
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
      await widget.onDeleteFinish(finish);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleFinishes = widget.finishes
      .where((finish) => finish.multiplier == _selectedMultiplier)
      .toList();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  DateFilterSelector(
                    selectedFilter: widget.selectedDateFilter,
                    onSelectionChanged: widget.onDateFilterChanged,
                  ),
                  const Spacer(),
                  FinishMultiplierSelector(
                    selectedMultiplier: _selectedMultiplier,
                    onSelectionChanged: (multiplier) {
                      setState(() {
                        _selectedMultiplier = multiplier;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FinishGrid(
                multiplier: _selectedMultiplier,
                onSelected: (field) {
                  widget.onSaveFinish(
                    NewFinishEntry(
                      field: field,
                      multiplier: _selectedMultiplier,
                      timestamp: DateTime.now()
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              FinishChart(finishes: visibleFinishes),
              const SizedBox(height: 24),
              const Text(
                'Historie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (visibleFinishes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Noch keine Finishes erfasst.')),
                )
              else
                ...visibleFinishes.map<Widget>((finish) {
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
                          finish.field == 50
                            ? 'Bull'
                            : '${finish.multiplier == FinishMultiplier.double ? 'D' : 'T'}${finish.field}',
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
