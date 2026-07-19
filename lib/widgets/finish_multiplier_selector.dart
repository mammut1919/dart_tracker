import 'package:flutter/material.dart';

import '../models/finish_multiplier.dart';

class FinishMultiplierSelector extends StatelessWidget {
  const FinishMultiplierSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FinishMultiplier>(
      segments: const [
        //ButtonSegment(
        //  value: FinishMultiplier.single,
        //  label: Text('Single'),
        //  enabled: false,
        //),
        ButtonSegment(value: FinishMultiplier.double, label: Text('Double')),
        ButtonSegment(
          value: FinishMultiplier.triple,
          label: Text('Triple'),
          enabled: false,
        ),
      ],
      selected: const {FinishMultiplier.double},
      onSelectionChanged: null,
    );
  }
}
