import 'package:flutter/material.dart';

import 'about_dart_tracker_dialog.dart';
import 'appearance_dialog.dart';
import 'data_dialog.dart';
import 'statistics_dialog.dart';
import '../settings/app_settings.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onExportBackup,
    required this.onImportBackup,
    required this.onResetData,
  });

  final AppSettings settings;
  final Future<void> Function() onExportBackup;
  final Future<void> Function() onImportBackup;
  final VoidCallback onResetData;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Einstellungen'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // statistics
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Statistik'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => StatisticsDialog(
                    settings: settings,
                  ),
                );
              },
            ),
            // data
            ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Daten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => DataDialog(
                  onExportBackup: onExportBackup,
                  onImportBackup: onImportBackup,
                  onResetData: onResetData,
                ),
              );
            },
          ),
            // appearence
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Darstellung'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => const AppearanceDialog(),
                );
              },
            ),
            // about
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Über Dart Tracker'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => const AboutDartTrackerDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
