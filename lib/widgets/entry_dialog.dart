import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/entry_option.dart';
import '../models/entry_options.dart';
import '../models/new_entry.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({super.key, this.initialOption});

  final EntryOption? initialOption;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  late EntryOption _selectedOption;

  DateTime _selectedDate = DateTime.now();

  final TextEditingController _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedOption = widget.initialOption ?? availableEntryOptions.first;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    final int value;

    if (_selectedOption.requiresInput) {
      value = int.tryParse(_valueController.text) ?? 0;
    } else {
      value = _selectedOption.presetValue!;
    }

    Navigator.pop(
      context,
      NewEntry(
        type: _selectedOption.type,
        value: value,
        timestamp: _selectedDate,
      ),
    );
  }

  bool get _canSave {
    if (!_selectedOption.requiresInput) {
      return true;
    }

    final value = int.tryParse(_valueController.text);

    return value != null && _selectedOption.isValidValue(value);
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Treffer hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<EntryOption>(
            initialValue: _selectedOption,
            decoration: const InputDecoration(labelText: 'Eintrag'),
            items: availableEntryOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option.label),
                  ),
                )
                .toList(),
            onChanged: (option) {
              if (option != null) {
                setState(() {
                  _selectedOption = option;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _pickDate,
            child: Text(
              '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
            ),
          ),
          if (_selectedOption.requiresInput) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              onChanged: (_) {
                setState(() {});
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: _selectedOption.inputLabelWithRange,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _canSave ? _save : null,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
