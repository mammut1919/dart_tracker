import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/finish_fields.dart';
import '../models/finish_multiplier.dart';
import '../models/new_finish_entry.dart';
import '../validation/finish_score_validator.dart';

class HighFinishDialog extends StatefulWidget {
  const HighFinishDialog({super.key});

  @override
  State<HighFinishDialog> createState() => _HighFinishDialogState();
}

class _HighFinishDialogState extends State<HighFinishDialog> {
  static const _validator = FinishScoreValidator();

  final _scoreController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _includeLastDart = false;
  int _field = 20;
  FinishMultiplier _multiplier = FinishMultiplier.double;
  FinishScoreValidation? _validation;

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

  void _validate() {
    final score = int.tryParse(_scoreController.text);

    setState(() {
      _validation = score == null || score < 100
          ? const FinishScoreValidation(
              isValid: false,
              errorMessage: 'Bitte einen High Finish Score von 100 bis 180 eingeben.',
            )
          : _validator.validate(
              score: score,
              field: _includeLastDart ? _field : null,
              multiplier: _includeLastDart ? _multiplier : null,
            );
    });
  }

  bool get _canSave => _validation?.isValid == true;

  void _save() {
    if (!_canSave) {
      return;
    }

    Navigator.pop(
      context,
      NewFinishEntry(
        field: _includeLastDart ? _field : null,
        multiplier: _includeLastDart ? _multiplier : null,
        timestamp: _selectedDate,
        score: int.parse(_scoreController.text),
      ),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('High Finish hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _scoreController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Finish Score (100-180)',
                errorText: _validation?.isValid == false
                    ? _validation?.errorMessage
                    : null,
              ),
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _pickDate,
              child: Text(
                '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Letzten Dart angeben'),
              value: _includeLastDart,
              onChanged: (value) {
                setState(() {
                  _includeLastDart = value ?? false;
                });
                _validate();
              },
            ),
            if (_includeLastDart) ...[
              DropdownButtonFormField<FinishMultiplier>(
                initialValue: _multiplier,
                decoration: const InputDecoration(labelText: 'Multiplier'),
                items: FinishMultiplier.values
                    .map(
                      (multiplier) => DropdownMenuItem(
                        value: multiplier,
                        child: Text(multiplier.label),
                      ),
                    )
                    .toList(),
                onChanged: (multiplier) {
                  if (multiplier == null) {
                    return;
                  }

                  setState(() {
                    _multiplier = multiplier;
                  });
                  _validate();
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _field,
                decoration: const InputDecoration(labelText: 'Letzter Dart'),
                items: finishFields
                    .map(
                      (field) => DropdownMenuItem(
                        value: field,
                        child: Text(field == 25 ? 'Bull' : '$field'),
                      ),
                    )
                    .toList(),
                onChanged: (field) {
                  if (field == null) {
                    return;
                  }

                  setState(() {
                    _field = field;
                  });
                  _validate();
                },
              ),
            ],
          ],
        ),
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
