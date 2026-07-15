import 'package:flutter/material.dart';

import 'home_page.dart';
import 'settings/app_settings.dart';
import 'settings/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = SettingsRepository();

  final settings = await repository.load();

  runApp(
    DartTrackerApp(
      settings: settings,
    ),
  );
}

class DartTrackerApp extends StatelessWidget {
  const DartTrackerApp({
    super.key,
    required this.settings,
    });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: HomePage(
        settings: settings,
      ),
    );
  }
}