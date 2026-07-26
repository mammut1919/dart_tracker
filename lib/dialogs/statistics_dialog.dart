import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../settings/app_settings.dart';

class StatisticsDialog extends StatefulWidget {
  const StatisticsDialog({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<StatisticsDialog> createState() => _StatisticsDialogState();
}

class _StatisticsDialogState extends State<StatisticsDialog> {
  late int _shortLegLimit;
  late final TextEditingController _baseline180Controller;
  late final TextEditingController _baseline171Controller;
  late final TextEditingController _baseline162Controller;
  late final TextEditingController _baselineHighFinishController;
  late final TextEditingController _baselineShortLegController;


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _shortLegLimit = widget.settings.shortLegLimit;

    _baseline180Controller = TextEditingController(
      text: widget.settings.baseline180.toString(),
    );

    _baseline171Controller = TextEditingController(
      text: widget.settings.baseline171.toString(),
    );

    _baseline162Controller = TextEditingController(
      text: widget.settings.baseline162.toString(),
    );

    _baselineHighFinishController = TextEditingController(
      text: widget.settings.baselineHighFinish.toString(),
    );

    _baselineShortLegController = TextEditingController(
      text: widget.settings.baselineShortLeg.toString(),
    );
  }

  @override
  void dispose() {
    _baseline180Controller.dispose();
    _baseline171Controller.dispose();
    _baseline162Controller.dispose();
    _baselineHighFinishController.dispose();
    _baselineShortLegController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Statistik-Einstellungen'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grenze für Short Leg',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ein Short Leg wird bis einschließlich der ausgewählten Anzahl an Darts gezählt.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              initialValue: _shortLegLimit,
              decoration: const InputDecoration(
                labelText: 'Short Leg bis',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 18, child: Text('18 Darts')),
                DropdownMenuItem(value: 21, child: Text('21 Darts')),
                DropdownMenuItem(value: 24, child: Text('24 Darts')),
                DropdownMenuItem(value: 27, child: Text('27 Darts')),
                DropdownMenuItem(value: 30, child: Text('30 Darts')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _shortLegLimit = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Startwerte',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Trage hier deine bereits erzielten Treffer vor der Nutzung von Dart Tracker ein.\n'
              'Diese Werte werden als Startbestand für deine Statistiken verwendet.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 16),

            _buildField('180', _baseline180Controller),
            _buildField('171', _baseline171Controller),
            _buildField('162', _baseline162Controller),
            _buildField('High Finish', _baselineHighFinishController),
            _buildField('Short Leg', _baselineShortLegController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.pop(
              context,
              widget.settings.copyWith(
                shortLegLimit: _shortLegLimit,
                baseline180: int.parse(_baseline180Controller.text),
                baseline171: int.parse(_baseline171Controller.text),
                baseline162: int.parse(_baseline162Controller.text),
                baselineHighFinish: int.parse(
                  _baselineHighFinishController.text,
                ),
                baselineShortLeg: int.parse(
                  _baselineShortLegController.text,
                ),
              ),
            );
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte eingeben';
          }

          final number = int.tryParse(value);

          if (number == null) {
            return 'Ungültige Zahl';
          }

          if (number < 0) {
            return 'Muss ≥ 0 sein';
          }

          return null;
        },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
