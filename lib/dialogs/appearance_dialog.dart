import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';

import '../settings/app_settings.dart';

class AppearanceDialog extends StatefulWidget {
  const AppearanceDialog({
    super.key,
    required this.settings,
  });

  final AppSettings settings;

  @override
  State<AppearanceDialog> createState() => _AppearanceDialogState();
}

class _AppearanceDialogState extends State<AppearanceDialog> {
  late ThemeMode _themeMode;

  late Color _score180Color;
  late Color _score171Color;
  late Color _score162Color;
  late Color _highFinishColor;
  late Color _shortLegColor;

  @override
  void initState() {
    super.initState();

    _score180Color = widget.settings.score180Color;
    _score171Color = widget.settings.score171Color;
    _score162Color = widget.settings.score162Color;
    _highFinishColor = widget.settings.highFinishColor;
    _shortLegColor = widget.settings.shortLegColor;

    _themeMode = _themeModeFromString(widget.settings.themeMode);
  }

  Widget _buildColorRow({
    required String label,
    required Color color,
    required ValueChanged<Color> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showColorPicker(
              title: label,
              initialColor: color,
              onChanged: onChanged,
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showColorPicker({
    required String title,
    required Color initialColor,
    required ValueChanged<Color> onChanged,
  }) async {
    Color selectedColor = initialColor;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Farbe für $title'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                onChanged(selectedColor);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetColors() {
    // TODO
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;

      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Darstellung'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Design',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Hell'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dunkel'),
              ),
            ],
            selected: {_themeMode},
            onSelectionChanged: (selection) {
              setState(() {
                _themeMode = selection.first;
              });
            },
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 12),

          Row(
            children: [
              const Text(
                'Farben',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetColors,
                child: const Text('Zurücksetzen'),
              ),
            ],
          ),

          _buildColorRow(
            label: '180',
            color: _score180Color,
            onChanged: (color) {
              setState(() {
                _score180Color = color;
              });
            },
          ),

          _buildColorRow(
            label: '171',
            color: _score171Color,
            onChanged: (color) {
              setState(() {
                _score171Color = color;
              });
            },
          ),

          _buildColorRow(
            label: '162',
            color: _score162Color,
            onChanged: (color) {
              setState(() {
                _score162Color = color;
              });
            },
          ),

          _buildColorRow(
            label: 'High Finish',
            color: _highFinishColor,
            onChanged: (color) {
              setState(() {
                _highFinishColor = color;
              });
            },
          ),

          _buildColorRow(
            label: 'Short Leg',
            color: _shortLegColor,
            onChanged: (color) {
              setState(() {
                _shortLegColor = color;
              });
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              widget.settings.copyWith(
                themeMode: _themeMode == ThemeMode.dark
                  ? 'dark'
                  : 'light',
                score180ColorValue: _score180Color.toARGB32(),
                score171ColorValue: _score171Color.toARGB32(),
                score162ColorValue: _score162Color.toARGB32(),
                highFinishColorValue: _highFinishColor.toARGB32(),
                shortLegColorValue: _shortLegColor.toARGB32(),
              ),
            );
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}