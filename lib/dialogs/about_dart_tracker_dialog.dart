import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutDartTrackerDialog extends StatefulWidget {
  const AboutDartTrackerDialog({super.key});

  @override
  State<AboutDartTrackerDialog> createState() => _AboutDartTrackerDialogState();
}

class _AboutDartTrackerDialogState extends State<AboutDartTrackerDialog> {
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
      _version = info.version;
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
Dart Tracker


Dart Tracker unterstützt dich beim Erfassen deiner persönlichen Trainingsstatistiken - schnell, einfach und ohne unnötigen Aufwand.


Features:
• Erfassung von 180, 171 und 162
• High Finishes und Short Legs
• Double- und Triple-Finish-Tracking
• Erfassung des letzten Darts oder des vollständigen Finishes
• Optionale Finish-Scores mit Checkout-Validierung
• Zeitraumfilter für Statistiken und Finishes
• Finishes-, Durchschnitts- und Aktivitätsstatistiken
• Interaktive Diagramme und Finish-Übersicht
• Statistik-Aggregation nach Tag, Woche, Monat und Jahr
• Individuelle Startwerte für persönliche Statistiken
• Anpassbare Farben sowie Hell- und Dunkelmodus
• Backup und Wiederherstellung aller Daten


Die App konzentriert sich bewusst auf die wichtigsten Trainingsdaten und verzichtet auf komplexes Match-Tracking.


Vielen Dank an alle Beta-Tester für ihr wertvolles Feedback.


Gut Dart!


''';