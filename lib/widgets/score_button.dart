import 'package:flutter/material.dart';

import '../models/score_definition.dart';

class ScoreButton extends StatelessWidget {
  const ScoreButton({
    super.key,
    required this.definition,
    required this.onPressed,
  });

  final ScoreDefinition definition;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: definition.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      onPressed: onPressed,
      child: Text(
        '${definition.score}',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}