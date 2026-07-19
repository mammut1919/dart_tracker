import 'package:flutter/material.dart';

import '../models/app_page.dart';

class PageSelector extends StatelessWidget {
  const PageSelector({super.key, required this.page, required this.onChanged});

  final AppPage page;
  final ValueChanged<AppPage> onChanged;

  String get _title {
    switch (page) {
      case AppPage.entries:
        return 'Dart Tracker';
      case AppPage.finishes:
        return 'Finishes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppPage>(
      tooltip: 'Seite auswählen',
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppPage.entries,
          child: Row(
            children: [
              if (page == AppPage.entries)
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('Dart Tracker'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppPage.finishes,
          child: Row(
            children: [
              if (page == AppPage.finishes)
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('Finishes'),
            ],
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_title, style: Theme.of(context).textTheme.headlineSmall),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
