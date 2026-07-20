import 'package:flutter/material.dart';

import '../models/date_filter.dart';

class DateFilterSelector extends StatelessWidget {
  const DateFilterSelector({
    super.key,
    required this.selectedFilter,
    required this.onSelectionChanged,
  });

  final DateFilter selectedFilter;
  final ValueChanged<DateFilter> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<DateFilter>(
          initialValue: selectedFilter,
          onSelected: onSelectionChanged,
          itemBuilder: (context) => DateFilter.values
              .map(
                (filter) => PopupMenuItem<DateFilter>(
                  value: filter,
                  child: Text(filter.label),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedFilter.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }
}