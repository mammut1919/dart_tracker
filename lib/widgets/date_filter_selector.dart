import 'package:flutter/material.dart';

import '../models/date_filter.dart';

class DateFilterSelector extends StatelessWidget {
  const DateFilterSelector({
    super.key,
    required this.selectedFilter,
    required this.onSelectionChanged,
    this.countForFilter,
  });

  final DateFilter selectedFilter;
  final ValueChanged<DateFilter> onSelectionChanged;
  final int Function(DateFilter filter)? countForFilter;

  String _label(DateFilter filter) {
    final count = countForFilter?.call(filter);

    if (count == null) {
      return filter.label;
    }

    return '${filter.label} ($count)';
  }

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
                  child: Text(_label(filter)),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _label(selectedFilter),
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