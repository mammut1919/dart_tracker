import 'package:flutter/material.dart';

import '../models/new_finish_entry.dart';
import '../widgets/finish_chart.dart';
import '../widgets/finish_grid.dart';


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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              FinishGrid(
                onSelected: (field) {
                  onSaveFinish(
                    NewFinishEntry(
                      field: field,
                      timestamp: DateTime.now(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              FinishChart(
                finishes: finishes,
              ),

              const SizedBox(height: 24),

              const Text(
                'Historie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (finishes.isEmpty)
                const Card(
                  child: ListTile(
                    title: Text(
                      'Noch keine Finishes erfasst.',
                    ),
                  ),
                ),

              ...finishes.map(
                (finish) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.gps_fixed,
                    ),
                    title: Text(
                      finish.field == 50
                          ? 'Bull'
                          : 'D${finish.field}',
                    ),
                    subtitle: Text(
                      '${finish.timestamp.day.toString().padLeft(2, '0')}.'
                      '${finish.timestamp.month.toString().padLeft(2, '0')}.'
                      '${finish.timestamp.year}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}