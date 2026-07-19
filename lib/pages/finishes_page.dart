import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';
import '../database/finish_storage.dart';
import '../models/new_finish_entry.dart';
import '../widgets/finish_grid.dart';

class FinishesPage extends StatefulWidget {
  const FinishesPage({
    super.key,
  });

  @override
  State<FinishesPage> createState() =>
      _FinishesPageState();
}

class _FinishesPageState extends State<FinishesPage> {
  final _database = AppDatabase();

  late final FinishStorage _storage;

  List<NewFinishEntry> _finishes = [];

  @override
  void initState() {
    super.initState();

    _storage = FinishStorage(_database);

    _loadFinishes();
  }

  Future<void> _loadFinishes() async {
    final finishes = await _storage.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _finishes = finishes;
    });
  }

  Future<void> _saveFinish(
    int field,
  ) async {
    HapticFeedback.selectionClick();

    await _storage.add(
      field,
      DateTime.now(),
    );

    await _loadFinishes();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          field == 50
              ? 'Bull gespeichert.'
              : 'D$field gespeichert.',
        ),
      ),
    );
  }

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
                onSelected: _saveFinish,
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

              if (_finishes.isEmpty)
                const Card(
                  child: ListTile(
                    title: Text(
                      'Noch keine Finishes erfasst.',
                    ),
                  ),
                ),

              ..._finishes.map(
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