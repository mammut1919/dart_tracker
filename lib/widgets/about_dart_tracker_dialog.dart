import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutDartTrackerDialog extends StatefulWidget {
  const AboutDartTrackerDialog({
    super.key,
  });

  @override
  State<AboutDartTrackerDialog> createState() =>
      _AboutDartTrackerDialogState();
}

class _AboutDartTrackerDialogState
  extends State<AboutDartTrackerDialog> {

  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _version = '${info.version} (Build ${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dart Tracker'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version $_version',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(_aboutText),
          ],
        ),
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

const _aboutText = '''
Der Dart Tracker hilft dabei, besondere Erfolge beim Darts dauerhaft festzuhalten und ihren Verlauf über die Zeit zu verfolgen.

Erfasst werden können:

• 180er
• 171er
• 162er
• High Finishes
• Short Legs

Für jede Kategorie können Startwerte hinterlegt werden. So lassen sich bereits erzielte Erfolge übernehmen, ohne alle bisherigen Ergebnisse nachträglich erfassen zu müssen.

Alle Einträge werden in einem gemeinsamen Diagramm dargestellt. Dadurch lässt sich die persönliche Entwicklung über einen beliebigen Zeitraum nachvollziehen.

Die Daten werden ausschließlich lokal auf deinem Gerät gespeichert. Über die integrierte Backup-Funktion können sie exportiert und bei Bedarf jederzeit wieder importiert werden.

Gut Dart!
''';