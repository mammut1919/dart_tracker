import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backup/backup_service.dart';
import 'backup/backup_file_service.dart';
import 'database/database.dart';
import 'database/score_storage.dart';
import 'database/finish_storage.dart';
import 'models/app_page.dart';
import 'models/entry_option.dart';
import 'models/new_entry.dart';
import 'models/new_finish_entry.dart';
import 'pages/entries_page.dart';
import 'pages/finishes_page.dart';
import 'settings/app_settings.dart';
import 'settings/settings_repository.dart';
import 'widgets/entry_dialog.dart';
import 'widgets/about_dart_tracker_dialog.dart';
import 'widgets/settings_dialog.dart';
import 'widgets/page_selector.dart';

enum _MenuAction {
  exportBackup,
  importBackup,
  resetData,
  about,
}

class RootPage extends StatefulWidget {
  const RootPage({
    super.key,
    required this.settings
  });

  final AppSettings settings;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late AppSettings _settings;

  late final AppDatabase _database;
  late final ScoreStorage _storage;
  late final FinishStorage _finishStorage;
  late final SettingsRepository _settingsRepository;

  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  AppPage _currentPage = AppPage.entries;


  List<NewEntry> _entries = [];
  List<NewFinishEntry> _finishes = [];

  @override
  void initState() {
    super.initState();

    _settings = widget.settings;

    _database = AppDatabase();
    _storage = ScoreStorage(_database);
    _finishStorage = FinishStorage(_database);

    _settingsRepository = SettingsRepository();

    _reloadData();
  }

  Future<void> _loadEntries() async {
    final entries = await _storage.getAll();

    if (!mounted) return;

    setState(() {
      _entries = entries;
    });
  }

  Future<void> _loadFinishes() async {
    final finishes = await _finishStorage.getAll();

    if (!mounted) return;

    setState(() {
      _finishes = finishes;
    });
  }

  Future<void> _reloadData() async {
    await _loadEntries();
    await _loadFinishes();
  }

  Future<void> _updateSettings(
    AppSettings settings,
  ) async {
    await _settingsRepository.save(settings);

    setState(() {
      _settings = settings;
    });
  }

  Future<void> _addEntry(NewEntry entry) async {
    await _storage.add(
      entry.type,
      entry.value,
      entry.timestamp,
    );

    await _loadEntries();
  }

  Future<void> _deleteEntry(int id) async {
    await _storage.delete(id);

    await _loadEntries();
  }

  Future<void> _saveFinish(NewFinishEntry finish) async {
    await _finishStorage.add(
      finish.field,
      finish.timestamp,
    );

    await _loadFinishes();
  }

  Future<void> _deleteFinish(NewFinishEntry finish) async {
    if (finish.id == null) {
      return;
    }

    await _finishStorage.delete(finish.id!);

    await _loadFinishes();
  }

  Future<void> _showAddDialog({
    EntryOption? initialOption,
  })  async {
    final entry = await showDialog<NewEntry>(
      context: context,
      builder: (_) => EntryDialog(
        initialOption: initialOption,
      ),
    );

    if (entry == null) {
      return;
    }

    await _addEntry(entry);

    await _loadEntries();
  }

  Future<void> _confirmDelete(NewEntry entry) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eintrag löschen'),
        content: Text(
          'Möchtest du den Treffer ${entry.value} vom '
          '${_dateFormat.format(entry.timestamp)} wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (delete == true) {
      await _deleteEntry(entry.id!);
    }
  }

  Future<void> _showSettingsDialog() async {
    final settings = await showDialog<AppSettings>(
      context: context,
      builder: (context) => SettingsDialog(
        settings: _settings,
      ),
    );

    if (settings == null) {
      return;
    }

    await _updateSettings(settings);
  }

  Future<void> _onMenuSelected(
    _MenuAction action,
  ) async {
    switch (action) {
      case _MenuAction.exportBackup:
        await _exportBackup();
        break;

      case _MenuAction.importBackup:
        await _importBackup();
        break;

      case _MenuAction.resetData:
        _confirmResetData();
        break;

      case _MenuAction.about:
        showDialog(
          context: context,
          builder: (_) => const AboutDartTrackerDialog(),
        );
        break;
    }
  }

  Future<void> _exportBackup() async {
    const backupService = BackupService();
    final backupFileService = BackupFileService();

    final json = backupService.export(
      settings: _settings,
      entries: _entries,
      finishes: _finishes,
    );

    final success = await backupFileService.saveBackup(json);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Backup erfolgreich gespeichert.'
              : 'Backup wurde abgebrochen.',
        ),
      ),
    );
  }

  Future<void> _importBackup() async {
    final backupFileService = BackupFileService();
    final backupService = BackupService();

    final json = await backupFileService.loadBackup();

    if (json == null) {
      return;
    }

    try {
      final backup = backupService.importFromJson(json);

      final confirmed = await _confirmImport();

      if (!confirmed) {
        return;
      }

      await _storage.clear();

      for (final entry in backup.entries) {
        await _storage.add(
          entry.type,
          entry.value,
          entry.timestamp,
        );
      }

      for (final finish in backup.finishes) {
        await _finishStorage.add(
          finish.field,
          finish.timestamp,
        );
      }

      await _settingsRepository.save(backup.settings);

      if (!mounted) return;

      setState(() {
        _settings = backup.settings;
      });

      await _reloadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup erfolgreich importiert.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ungültige Backup-Datei.'),
        ),
      );
    }
  }

  Future<bool> _confirmImport() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Backup importieren'),
          content: const Text(
            'Alle vorhandenen Daten und Einstellungen werden durch das Backup ersetzt. '
            'Diese Aktion kann nicht rückgängig gemacht werden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Importieren'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _confirmResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Daten zurücksetzen'),
          content: const Text(
            'Alle erfassten Einträge werden dauerhaft gelöscht.\n\n'
            'Die App wird auf die Werkseinstellungen zurückgesetzt \n\n'
            'Möchtest du fortfahren?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Zurücksetzen'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _resetData();
  }

  Future<void> _clearAllData() async {
    await _storage.clear();
    await _finishStorage.clear();
  }

  Future<void> _resetData() async {
    await _clearAllData();

    await _settingsRepository.save(
      AppSettings.initial,
    );

    if (!mounted) return;

    setState(() {
      _settings = AppSettings.initial;
    });

    await _reloadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Alle Daten wurden zurückgesetzt.',
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageSelector(
          page: _currentPage,
          onChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Einstellungen',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Eintrag hinzufügen',
          ),
          PopupMenuButton<_MenuAction>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _MenuAction.exportBackup,
                child: Text('Backup exportieren'),
              ),
              PopupMenuItem(
                value: _MenuAction.importBackup,
                child: Text('Backup importieren'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _MenuAction.resetData,
                child: Text('Daten zurücksetzen'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _MenuAction.about,
                child: Text('Über Dart Tracker'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPage.index,
        children: [
          EntriesPage(
            entries: _entries,
            settings: _settings,
            dateFormat: _dateFormat,
            onAddEntry: _addEntry,
            onShowAddDialog: _showAddDialog,
            onConfirmDelete: _confirmDelete,
          ),
          FinishesPage(
            finishes: _finishes,
            onSaveFinish: _saveFinish,
            onDeleteFinish: _deleteFinish,
          ),
        ],
      ),     
    );
  }
}