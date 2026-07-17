import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../settings/app_settings.dart';


class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.settings,
  });

  final AppSettings settings;

  @override
  State<SettingsDialog> createState() =>
      _SettingsDialogState();
}

class _SettingsDialogState
    extends State<SettingsDialog> {

  late final TextEditingController _baseline180Controller;
  late final TextEditingController _baseline171Controller;
  late final TextEditingController _baseline162Controller;
  late final TextEditingController _baselineHighFinishController;
  late final TextEditingController _baselineShortLegController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

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
      title: const Text(
        'Startwerte',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(
              '180',
              _baseline180Controller,
            ),
            _buildField(
              '171',
              _baseline171Controller,
            ),
            _buildField(
              '162',
              _baseline162Controller,
            ),
            _buildField(
            'High Finish',
              _baselineHighFinishController,
            ),

            _buildField(
              'Short Leg',
              _baselineShortLegController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Abbrechen',
          ),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.pop(
              context,
              widget.settings.copyWith(
                baseline180:
                    int.parse(
                      _baseline180Controller.text,
                    ),
                baseline171:
                    int.parse(
                      _baseline171Controller.text,
                    ),
                baseline162:
                    int.parse(
                      _baseline162Controller.text,
                    ),
                baselineHighFinish: int.parse(
                  _baselineHighFinishController.text,
                ),

                baselineShortLeg: int.parse(
                  _baselineShortLegController.text,
                ),
              ),
            );
          },
          child: const Text(
            'Speichern',
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
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
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}