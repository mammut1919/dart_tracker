import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backup/backup_service.dart';
import 'backup/backup_file_service.dart';
import 'database/database.dart';
import 'database/score_storage.dart';
import 'database/finish_storage.dart';
import 'dialogs/settings_dialog.dart';
import 'models/analytics_type.dart';
import 'models/app_page.dart';
import 'models/entry_type.dart';
import 'models/date_filter.dart';
import 'models/finish_multiplier.dart';
import 'models/new_entry.dart';
import 'models/new_finish_entry.dart';
import 'pages/analytics_page.dart';
import 'pages/entries_page.dart';
import 'pages/finishes_page.dart';
import 'settings/app_settings.dart';
import 'settings/settings_repository.dart';
import 'widgets/entry_dialog.dart';
import 'widgets/high_finish_dialog.dart';
import 'widgets/page_selector.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

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
  DateFilter _selectedDateFilter = DateFilter.allTime;

  AppPage _currentPage = AppPage.entries; 
  AnalyticsType _currentAnalytics = AnalyticsType.personalBests;

  static const _navigationPages = [
    _NavigationTarget(AppPage.entries),
    _NavigationTarget(AppPage.finishes),
    _NavigationTarget(
      AppPage.analytics,
      analyticsType: AnalyticsType.personalBests,
    ),
    _NavigationTarget(
      AppPage.analytics,
      analyticsType: AnalyticsType.finishes,
    ),
    _NavigationTarget(
      AppPage.analytics,
      analyticsType: AnalyticsType.averageFinish,
    ),
    _NavigationTarget(
      AppPage.analytics,
      analyticsType: AnalyticsType.averageFinishDart,
    ),
    _NavigationTarget(
      AppPage.analytics,
      analyticsType: AnalyticsType.activity,
    ),
  ];

  int get _navigationIndex {
    if (_currentPage == AppPage.entries) {
      return 0;
    }

    if (_currentPage == AppPage.finishes) {
      return 1;
    }

    return 2 + AnalyticsType.values.indexOf(_currentAnalytics);
  }

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

  void _setDateFilter(DateFilter filter) {
    setState(() {
      _selectedDateFilter = filter;
    });
  }

  void _setAnalyticsType(AnalyticsType analytics) {
    if (analytics == AnalyticsType.activity &&
        _selectedDateFilter == DateFilter.today) {
      _selectedDateFilter = DateFilter.last7Days;
    }

    setState(() {
      _currentAnalytics = analytics;
    });
  }

  void _navigateSwipe(int direction) {
    final currentIndex = _navigationIndex;
    final newIndex = currentIndex + direction;

    if (newIndex < 0 || newIndex >= _navigationPages.length) {
      return;
    }

    final page = _navigationPages[newIndex];

    if (page.analyticsType != null) {
      _setAnalyticsType(page.analyticsType!);
    }

    setState(() {
      _currentPage = page.page;
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatEntry(NewEntry entry) {
    return entry.type.format(entry.value);
  }

  String _formatFinish(NewFinishEntry finish) {
    if (finish.score != null && finish.score! >= 100) {
      return 'High Finish (${finish.score})';
    }

    if (finish.field == 25 &&
        finish.multiplier == FinishMultiplier.double) {
      return 'Bull Finish';
    }

    if (finish.field != null && finish.multiplier != null) {
      final multiplier = finish.multiplier == FinishMultiplier.double ? 'D' : 'T';
      return '$multiplier${finish.field} Finish';
    }

    return 'Finish';
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

  Future<void> _updateSettings(AppSettings settings) async {
    await _settingsRepository.save(settings);

    setState(() {
      _settings = settings;
    });

    widget.onSettingsChanged(settings);
  }

  Future<void> _addEntry(NewEntry entry) async {
    await _storage.add(entry.type, entry.value, entry.timestamp);
    await _loadEntries();
    _showMessage('${_formatEntry(entry)} gespeichert.');
  }

  Future<void> _deleteEntry(NewEntry entry) async {
    await _storage.delete(entry.id!);
    await _loadEntries();
    _showMessage('${_formatEntry(entry)} gelöscht.');
  }

  Future<void> _saveFinish(NewFinishEntry finish) async {
    await _finishStorage.add(finish.field, finish.multiplier, finish.timestamp, score: finish.score);
    await _loadFinishes();
    _showMessage('${_formatFinish(finish)} gespeichert.');
  }

  Future<void> _deleteFinish(NewFinishEntry finish) async {
    await _finishStorage.delete(finish.id!);
    await _loadFinishes();
    _showMessage('${_formatFinish(finish)} gelöscht.');
  }

  Future<void> _showHighFinishDialog() async {
    final finish = await showDialog<NewFinishEntry>(
      context: context,
      builder: (_) => const HighFinishDialog(),
    );

    if (finish == null) {
      return;
    }

    await _saveFinish(finish);
  }

  Future<void> _showAddDialog({EntryType? initialType}) async {
    final entry = await showDialog<NewEntry>(
      context: context,
      builder: (_) => EntryDialog(
        initialType: initialType,
        shortLegLimit: _settings.shortLegLimit,
      ),
    );

    if (entry == null) {
      return;
    }

    await _addEntry(entry);

    await _loadEntries();
  }

  Future<bool> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Löschen'),
        content: const Text('Eintrag wirklich löschen?'),
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

    return confirmed == true;
  }

  Future<void> _confirmDeleteEntry(NewEntry entry) async {
    if (await _confirmDelete()) {
      await _deleteEntry(entry);
    }
  }

  Future<void> _confirmDeleteFinish(NewFinishEntry finish) async {
    if (await _confirmDelete()) {
      await _deleteFinish(finish);
    }
  }

  Future<void> _showSettingsDialog() async {
    final settings = await showDialog<AppSettings>(
      context: context,
      builder: (_) => SettingsDialog(
        settings: _settings,
        onSettingsChanged: _updateSettings,
        onExportBackup: _exportBackup,
        onImportBackup: _importBackup,
        onResetData: _confirmResetData,
      ), 
    );

    if (settings == null) {
      return;
    }

    await _updateSettings(settings);
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

      await _clearAllData();

      for (final entry in backup.entries) {
        await _storage.add(entry.type, entry.value, entry.timestamp);
      }

      for (final finish in backup.finishes) {
        await _finishStorage.add(
          finish.field,
          finish.multiplier,
          finish.timestamp,
          score: finish.score,
        );
      }

      await _updateSettings(backup.settings);

      if (!mounted) return;

      await _reloadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup erfolgreich importiert.')),
      );
    } catch (_) {
      
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ungültige Backup-Datei.')));
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

    await _settingsRepository.save(AppSettings.initial);

    if (!mounted) return;

    setState(() {
      _settings = AppSettings.initial;
    });

    await _reloadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alle Daten wurden zurückgesetzt.')),
    );
  }

  List<NewEntry> get _filteredEntries {
    final startDate = _selectedDateFilter.startDate;

    if (startDate == null) {
      return _entries;
    }

    return _entries
        .where(
          (entry) => !entry.timestamp.isBefore(startDate),
        )
        .toList();
  }

  List<NewFinishEntry> get _filteredFinishes {
    final startDate = _selectedDateFilter.startDate;

    if (startDate == null) {
      return _finishes;
    }

    return _finishes
        .where(
          (finish) => !finish.timestamp.isBefore(startDate),
        )
        .toList();
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
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Eintrag hinzufügen',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettingsDialog,
              tooltip: 'Einstellungen',
            ),
          ) 
        ],
      ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;

            if (velocity < 0) {
              _navigateSwipe(1);
            } else if (velocity > 0) {
              _navigateSwipe(-1);
            }
          },
          child: IndexedStack(
            index: _currentPage.index,
            children: [
            EntriesPage(
              entries: _filteredEntries,
              settings: _settings,
              dateFormat: _dateFormat,
              selectedDateFilter: _selectedDateFilter,
              onDateFilterChanged: _setDateFilter,
              onAddEntry: _addEntry,
              onShowAddDialog: _showAddDialog,
              onAddHighFinish: _showHighFinishDialog,
              onDeleteFinish: _deleteFinish,
              onConfirmDelete: _confirmDeleteEntry,
              onConfirmDeleteFinish: _confirmDeleteFinish,
              finishes: _filteredFinishes,
            ),
            FinishesPage(
              finishes: _filteredFinishes,
              allFinishes: _finishes,
              settings: _settings,
              selectedDateFilter: _selectedDateFilter,
              onDateFilterChanged: _setDateFilter,
              onSaveFinish: _saveFinish,
              onDeleteFinish: _deleteFinish,
              onConfirmDeleteFinish: _confirmDeleteFinish,
            ),
            AnalyticsPage(
              entries: _filteredEntries,
              finishes: _filteredFinishes,
              settings: _settings,
              selectedDateFilter: _selectedDateFilter,
              onDateFilterChanged: _setDateFilter,
              selectedAnalytics: _currentAnalytics,
              onAnalyticsChanged: _setAnalyticsType,
            ),
          ],
        ),
      )
    );
  }
}

class _NavigationTarget {
  const _NavigationTarget(
    this.page, {
    this.analyticsType,
  });

  final AppPage page;
  final AnalyticsType? analyticsType;
}