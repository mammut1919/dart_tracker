import 'package:flutter/material.dart';

import '../models/finish_multiplier.dart';
import '../settings/app_settings.dart';


class FinishMultiplierSelector extends StatelessWidget {
  const FinishMultiplierSelector({
    super.key,
    required this.selectedMultiplier,
    required this.onSelectionChanged,
    required this.settings,
  });

  final FinishMultiplier selectedMultiplier;
  final ValueChanged<FinishMultiplier> onSelectionChanged;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    ButtonStyle? style;

    if (settings.finishColor != null) {
      final selectedColor = Color.alphaBlend(
        (Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white)
            .withValues(alpha: 0.50),
        settings.finishColor!,
      );

      style = ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return selectedColor;
          }
          return null;
        }),
      );
    }

    return SegmentedButton<FinishMultiplier>(
      style: style,
      segments: const [
        ButtonSegment(
          value: FinishMultiplier.double,
          label: Text('Double'),
          icon: Icon(Icons.check),
        ),
        ButtonSegment(
          value: FinishMultiplier.triple,
          label: Text('Triple'),
        ),
      ],
      selected: {selectedMultiplier},
      onSelectionChanged: (selection) {
        onSelectionChanged(selection.first);
      },
    );
  }
}