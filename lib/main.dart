import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'root_page.dart';
import 'settings/app_settings.dart';
import 'settings/settings_repository.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('de_DE');

  final repository = SettingsRepository();

  final settings = await repository.load();

  runApp(DartTrackerApp(settings: settings));
}

class DartTrackerApp extends StatefulWidget {
  const DartTrackerApp({
    super.key,
    required this.settings
  });

  final AppSettings settings;

  @override
  State<DartTrackerApp> createState() => _DartTrackerAppState();
}

class _DartTrackerAppState extends State<DartTrackerApp> {
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();

    _settings = widget.settings;
  }

  void _updateSettings(AppSettings settings) {
    setState(() {
      _settings = settings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Tracker',
      locale: const Locale('de', 'DE'),
      supportedLocales: const [Locale('de', 'DE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
      ),

      darkTheme: ThemeData.dark(useMaterial3: true),

      themeMode: _settings.themeMode == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light,

      home: RootPage(
        settings: _settings,
        onSettingsChanged: _updateSettings,
      ),
    );
  }
}