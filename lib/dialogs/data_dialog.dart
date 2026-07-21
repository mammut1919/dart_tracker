import 'package:flutter/material.dart';

class DataDialog extends StatelessWidget {
  const DataDialog({
    super.key,
    required this.onExportBackup,
    required this.onImportBackup,
    required this.onResetData,
  });

  final Future<void> Function() onExportBackup;
  final Future<void> Function() onImportBackup;
  final VoidCallback onResetData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Daten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Backup exportieren'),
            onTap: () async {
              Navigator.pop(context);
              await onExportBackup();
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Backup importieren'),
            onTap: () async {
              Navigator.pop(context);
              await onImportBackup();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Daten zurücksetzen'),
            onTap: () {
              Navigator.pop(context);
              onResetData();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}