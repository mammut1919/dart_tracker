import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/date_filter.dart';
import '../models/finish_multiplier.dart';
import '../models/finish_tracking_mode.dart';
import '../models/new_finish_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/finish_chart.dart';
import '../widgets/finish_grid.dart';
import '../widgets/finish_multiplier_selector.dart';
import '../settings/app_settings.dart';
import '../validation/finish_score_validator.dart';

class FinishesPage extends StatefulWidget {
  const FinishesPage({
    super.key,
    required this.finishes,
    required this.allFinishes,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
    required this.onSaveFinish,
    required this.onDeleteFinish,
    required this.onConfirmDeleteFinish,
    required this.settings,
  });

  final List<NewFinishEntry> finishes;
  final List<NewFinishEntry> allFinishes;
  final DateFilter selectedDateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;
  final Future<void> Function(NewFinishEntry) onSaveFinish;
  final Future<void> Function(NewFinishEntry) onDeleteFinish;
  final Future<void> Function(NewFinishEntry) onConfirmDeleteFinish;
  final AppSettings settings;

  @override
  State<FinishesPage> createState() => _FinishesPageState();
}

class _FinishesPageState extends State<FinishesPage> {
  FinishMultiplier _selectedMultiplier = FinishMultiplier.double;
    bool _showAllHistory = false;

  int _countForFilter(DateFilter filter) {
    final startDate = filter.startDate;

    if (startDate == null) {
      return widget.allFinishes.length;
    }

    return widget.allFinishes.where((finish) {
      return !finish.timestamp.isBefore(startDate);
    }).length;
  }

  Future<int?> _showFinishScoreDialog(
    BuildContext context,
    int field,
    FinishMultiplier multiplier,
  ) {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return _FinishScoreDialog(
          field: field,
          multiplier: multiplier,
        );
      },
    );
  }

  Future<void> _handleFinishSelected(int field) async {
    final timestamp = DateTime.now();

    if (widget.settings.finishTrackingMode ==
        FinishTrackingMode.lastDart) {
      widget.onSaveFinish(
        NewFinishEntry(
          field: field,
          multiplier: _selectedMultiplier,
          timestamp: timestamp,
        ),
      );

      return;
    }

    final score = await _showFinishScoreDialog(context, field, _selectedMultiplier);

    if (score == null) {
      return;
    }

    widget.onSaveFinish(
      NewFinishEntry(
        field: field,
        multiplier: _selectedMultiplier,
        timestamp: timestamp,
        score: score,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleFinishes = widget.finishes
        .where((finish) => finish.multiplier == _selectedMultiplier)
        .toList();
    final historyFinishes = _showAllHistory
        ? visibleFinishes
        : visibleFinishes.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  DateFilterSelector(
                    selectedFilter: widget.selectedDateFilter,
                    onSelectionChanged: widget.onDateFilterChanged,
                    countForFilter: _countForFilter,
                  ),
                  const Spacer(),
                  FinishMultiplierSelector(
                    settings: widget.settings,
                    selectedMultiplier: _selectedMultiplier,
                    onSelectionChanged: (multiplier) {
                      setState(() {
                        _selectedMultiplier = multiplier;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FinishGrid(
                settings: widget.settings,
                multiplier: _selectedMultiplier,
                onSelected: _handleFinishSelected,
              ),
              const SizedBox(height: 16),
              FinishChart(
                finishes: visibleFinishes,
                multiplier: _selectedMultiplier,
                settings: widget.settings,
              ),
              const SizedBox(height: 24),
              const Text(
                'Historie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (visibleFinishes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Noch keine Finishes erfasst.')),
                )
              else
                ...historyFinishes.map<Widget>((finish) {
                  return Dismissible(
                    key: ValueKey(finish.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      await widget.onConfirmDeleteFinish(finish);
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      color: AppColors.delete,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      child: ListTile(
                        onLongPress: () =>
                            widget.onConfirmDeleteFinish(finish),
                        leading: const Icon(Icons.gps_fixed),
                        title: Text(
                          '${finish.field == 25 &&
                                  finish.multiplier == FinishMultiplier.double
                              ? 'Bull'
                              : '${finish.multiplier == FinishMultiplier.double ? 'D' : 'T'}${finish.field}'}'
                          '${finish.score != null ? ' (Finish: ${finish.score})' : ''}',
                        ),
                        subtitle: Text(
                          DateFormat('dd.MM.yyyy').format(finish.timestamp),
                        ),
                      ),
                    ),
                  );
                }),
                if (visibleFinishes.length > 3)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllHistory = !_showAllHistory;
                      });
                    },
                    child: Text(
                      _showAllHistory ? 'Weniger anzeigen' : 'Mehr anzeigen',
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinishScoreDialog extends StatefulWidget {
  const _FinishScoreDialog({
    required this.field,
    required this.multiplier,
  });

  final int field;
  final FinishMultiplier multiplier;

  @override
  State<_FinishScoreDialog> createState() => _FinishScoreDialogState();
}

class _FinishScoreDialogState extends State<_FinishScoreDialog> {
  late final TextEditingController _controller;
  late final int _defaultScore;

  static const _validator = FinishScoreValidator();

  bool _isValid = true;

  @override
  void initState() {
    super.initState();

    _defaultScore = widget.field * widget.multiplier.factor;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final text = _controller.text;

    if (text.isEmpty) {
      setState(() {
        _isValid = true;
      });
      return;
    }

    final score = int.tryParse(text);

    if (score == null) {
      setState(() {
        _isValid = false;
      });
      return;
    }

    final validation = _validator.validate(
      score: score,
      field: widget.field,
      multiplier: widget.multiplier,
    );

    setState(() {
      _isValid = validation.isValid;
    });
  }

  void _save() {
    if (!_isValid) {
      return;
    }

    final score = _controller.text.isEmpty
        ? _defaultScore
        : int.parse(_controller.text);

    Navigator.pop(context, score);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Finish Score'),
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Final Score',
          hintText: _defaultScore.toString(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (_) => _validate(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _isValid ? _save : null,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}