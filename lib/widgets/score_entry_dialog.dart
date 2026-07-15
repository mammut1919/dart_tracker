import 'package:flutter/material.dart';

import '../models/entry_type.dart';
import '../models/new_entry.dart';

class ScoreEntryDialog extends StatefulWidget {
  const ScoreEntryDialog({super.key});

  @override
  State<ScoreEntryDialog> createState() => _ScoreEntryDialogState();
}

class _ScoreEntryDialogState extends State<ScoreEntryDialog> {
  static const _scores = [180, 171, 162];

  int _selectedScore = _scores.first;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _save() {
    if (_selectedDate == null) {
      return;
    }

    Navigator.pop(
      context,
      NewEntry(
        type: EntryType.score,
        value: _selectedScore,
        timestamp: _selectedDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Treffer hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<int>(
            initialValue: _selectedScore,
            decoration: const InputDecoration(
              labelText: 'Score',
            ),
            items: _scores
                .map(
                  (score) => DropdownMenuItem(
                    value: score,
                    child: Text('$score'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedScore = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _pickDate,
            child: Text(
              _selectedDate == null
                  ? 'Datum auswählen'
                  : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _selectedDate == null ? null : _save,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}