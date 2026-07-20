import 'package:flutter/material.dart';

import '../models/finish_multiplier.dart';

class FinishMultiplierSelector extends StatelessWidget {
  const FinishMultiplierSelector({
    super.key,
    required this.selectedMultiplier,
    required this.onSelectionChanged,
  });

  final FinishMultiplier selectedMultiplier;
  final ValueChanged<FinishMultiplier> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FinishMultiplier>(
      segments: const [
        ButtonSegment(
          value: FinishMultiplier.double,
          label: Text('Double'),
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