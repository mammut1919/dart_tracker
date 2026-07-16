import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backup/backup_service.dart';
import 'backup/backup_file_service.dart';
import 'database/database.dart';
import 'database/score_storage.dart';
import 'models/entry_option.dart';
import 'models/entry_options.dart';
import 'models/entry_type.dart';
import 'models/new_entry.dart';
import 'models/default_scores.dart';
import 'settings/app_settings.dart';
import 'settings/settings_repository.dart';
import 'widgets/score_button.dart';
import 'widgets/score_chart.dart';
import 'widgets/entry_dialog.dart';
import 'widgets/entry_summary_card.dart';
import 'widgets/settings_dialog.dart';

enum _MenuAction {
  exportBackup,
  importBackup,
  about,
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.settings
  });

  final AppSettings settings;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppSettings _settings;

  late final AppDatabase _database;
  late final ScoreStorage _storage;
  late final SettingsRepository _settingsRepository;

  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  List<NewEntry> _entries = [];

  int _countEntries({
    required EntryType type,
    int? value,
  }) {
    return _entries.where((entry) {
      if (entry.type != type) {
        return false;
      }

      if (value != null) {
        return entry.value == value;
      }

      return true;
    }).length;
  }

  @override
  void initState() {
    super.initState();

    _settings = widget.settings;

    _database = AppDatabase();
    _storage = ScoreStorage(_database);

    _settingsRepository = SettingsRepository();

    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _storage.getAll();

    if (!mounted) return;

    setState(() {
      _entries = entries;
    });
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

  Future<void> _deleteEntry(int id) async {
    await _storage.delete(id);

    await _loadEntries();
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

      case _MenuAction.about:
        break;
    }
  }

  Future<void> _exportBackup() async {
    const backupService = BackupService();
    final backupFileService = BackupFileService();

    final json = backupService.export(
      settings: _settings,
      entries: _entries,
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
          EntryType.score,
          entry.value,
          entry.timestamp,
        );
      }

      await _settingsRepository.save(backup.settings);

      if (!mounted) return;

      setState(() {
        _settings = backup.settings;
      });

      await _loadEntries();

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

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count180 = _countEntries(
      type: EntryType.score,
      value: 180,
    );
    final count171 = _countEntries(
      type: EntryType.score,
      value: 171,
    );
    final count162 = _countEntries(
      type: EntryType.score,
      value: 162,
    );
    final countHF = _countEntries(
      type: EntryType.highFinish,
    );

    final countSL = _countEntries(
      type: EntryType.shortLeg,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Tracker'),
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
                value: _MenuAction.about,
                child: Text('Über Dart Tracker'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // score buttons
            Row(
              children: defaultScores.map((definition) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntryButton(
                      label: '${definition.score}',
                      color:  definition.color,
                      onPressed: () => _addEntry(
                        NewEntry(
                          type: EntryType.score,
                          value: definition.score,
                          timestamp: DateTime.now(),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // score summary cards
            Row(
              children: defaultScores.map((definition) {
                final rawCount = switch (definition.score) {
                  180 => count180,
                  171 => count171,
                  162 => count162,
                  _ => 0,
                };
                final displayCount = rawCount +  _settings.baselineFor(definition.score);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntrySummaryCard(
                      count: displayCount,
                      color: definition.color,
                      label: '${definition.score}',
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // other buttons
            Row(
              children: [

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntryButton(
                      label: 'High Finish',
                      color: Colors.deepPurple,
                      onPressed: () => _showAddDialog(
                        initialOption: highFinishOption,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntryButton(
                      label: 'Short Leg',
                      color: Colors.teal,
                      onPressed: () => _showAddDialog(
                        initialOption: shortLegOption,
                      ),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 8),
            // other summary cards
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntrySummaryCard(
                      count: countHF,
                      color: Colors.deepPurple,
                      label: 'HF',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: EntrySummaryCard(
                      count: countSL,
                      color: Colors.teal,
                      label: 'SL',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // score chart
            ScoreChart(
              entries: _entries,
              settings: _settings,
            ),
            const SizedBox(height: 24),
            // Hostory
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // List of historic scores
            Expanded(
              child: _entries.isEmpty 
              ? const Center(
                child: Text('Noch keine Treffer erfasst.'),
              )
              : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Dismissible(
                    key: ValueKey(entry.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteEntry(entry.id!),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        onLongPress: () => _confirmDelete(entry),
                        leading: const Icon(Icons.sports_score),
                        title: Text(entry.type.format(entry.value),),
                        subtitle: Text(_dateFormat.format(entry.timestamp),),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}