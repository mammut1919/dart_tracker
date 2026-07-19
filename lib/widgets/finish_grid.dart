import 'package:flutter/material.dart';

import '../models/finish_fields.dart';

class FinishGrid extends StatelessWidget {
  const FinishGrid({super.key, required this.onSelected});

  static const _buttonHeight = 32.0;

  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: finishFields.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            mainAxisExtent: _buttonHeight,
          ),
          itemBuilder: (context, index) {
            final field = finishFields[index];

            return FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => onSelected(field),
              child: Text(
                finishButtonLabel(field),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
