// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ScoreEntriesTable extends ScoreEntries
    with TableInfo<$ScoreEntriesTable, ScoreEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoreEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, score, type, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'score_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScoreEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoreEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoreEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ScoreEntriesTable createAlias(String alias) {
    return $ScoreEntriesTable(attachedDatabase, alias);
  }
}

class ScoreEntry extends DataClass implements Insertable<ScoreEntry> {
  final int id;
  final int score;
  final int type;
  final DateTime timestamp;
  const ScoreEntry({
    required this.id,
    required this.score,
    required this.type,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['score'] = Variable<int>(score);
    map['type'] = Variable<int>(type);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ScoreEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScoreEntriesCompanion(
      id: Value(id),
      score: Value(score),
      type: Value(type),
      timestamp: Value(timestamp),
    );
  }

  factory ScoreEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoreEntry(
      id: serializer.fromJson<int>(json['id']),
      score: serializer.fromJson<int>(json['score']),
      type: serializer.fromJson<int>(json['type']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'score': serializer.toJson<int>(score),
      'type': serializer.toJson<int>(type),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ScoreEntry copyWith({int? id, int? score, int? type, DateTime? timestamp}) =>
      ScoreEntry(
        id: id ?? this.id,
        score: score ?? this.score,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
      );
  ScoreEntry copyWithCompanion(ScoreEntriesCompanion data) {
    return ScoreEntry(
      id: data.id.present ? data.id.value : this.id,
      score: data.score.present ? data.score.value : this.score,
      type: data.type.present ? data.type.value : this.type,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoreEntry(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, score, type, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoreEntry &&
          other.id == this.id &&
          other.score == this.score &&
          other.type == this.type &&
          other.timestamp == this.timestamp);
}

class ScoreEntriesCompanion extends UpdateCompanion<ScoreEntry> {
  final Value<int> id;
  final Value<int> score;
  final Value<int> type;
  final Value<DateTime> timestamp;
  const ScoreEntriesCompanion({
    this.id = const Value.absent(),
    this.score = const Value.absent(),
    this.type = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ScoreEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int score,
    this.type = const Value.absent(),
    required DateTime timestamp,
  }) : score = Value(score),
       timestamp = Value(timestamp);
  static Insertable<ScoreEntry> custom({
    Expression<int>? id,
    Expression<int>? score,
    Expression<int>? type,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (score != null) 'score': score,
      if (type != null) 'type': type,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ScoreEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? score,
    Value<int>? type,
    Value<DateTime>? timestamp,
  }) {
    return ScoreEntriesCompanion(
      id: id ?? this.id,
      score: score ?? this.score,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoreEntriesCompanion(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $FinishEntriesTable extends FinishEntries
    with TableInfo<$FinishEntriesTable, FinishEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fieldMeta = const VerificationMeta('field');
  @override
  late final GeneratedColumn<int> field = GeneratedColumn<int>(
    'field',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, field, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finish_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinishEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('field')) {
      context.handle(
        _fieldMeta,
        field.isAcceptableOrUnknown(data['field']!, _fieldMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinishEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinishEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      field: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}field'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $FinishEntriesTable createAlias(String alias) {
    return $FinishEntriesTable(attachedDatabase, alias);
  }
}

class FinishEntry extends DataClass implements Insertable<FinishEntry> {
  final int id;
  final int field;
  final DateTime timestamp;
  const FinishEntry({
    required this.id,
    required this.field,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['field'] = Variable<int>(field);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  FinishEntriesCompanion toCompanion(bool nullToAbsent) {
    return FinishEntriesCompanion(
      id: Value(id),
      field: Value(field),
      timestamp: Value(timestamp),
    );
  }

  factory FinishEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinishEntry(
      id: serializer.fromJson<int>(json['id']),
      field: serializer.fromJson<int>(json['field']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'field': serializer.toJson<int>(field),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  FinishEntry copyWith({int? id, int? field, DateTime? timestamp}) =>
      FinishEntry(
        id: id ?? this.id,
        field: field ?? this.field,
        timestamp: timestamp ?? this.timestamp,
      );
  FinishEntry copyWithCompanion(FinishEntriesCompanion data) {
    return FinishEntry(
      id: data.id.present ? data.id.value : this.id,
      field: data.field.present ? data.field.value : this.field,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinishEntry(')
          ..write('id: $id, ')
          ..write('field: $field, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, field, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinishEntry &&
          other.id == this.id &&
          other.field == this.field &&
          other.timestamp == this.timestamp);
}

class FinishEntriesCompanion extends UpdateCompanion<FinishEntry> {
  final Value<int> id;
  final Value<int> field;
  final Value<DateTime> timestamp;
  const FinishEntriesCompanion({
    this.id = const Value.absent(),
    this.field = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  FinishEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int field,
    required DateTime timestamp,
  }) : field = Value(field),
       timestamp = Value(timestamp);
  static Insertable<FinishEntry> custom({
    Expression<int>? id,
    Expression<int>? field,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (field != null) 'field': field,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  FinishEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? field,
    Value<DateTime>? timestamp,
  }) {
    return FinishEntriesCompanion(
      id: id ?? this.id,
      field: field ?? this.field,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (field.present) {
      map['field'] = Variable<int>(field.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishEntriesCompanion(')
          ..write('id: $id, ')
          ..write('field: $field, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScoreEntriesTable scoreEntries = $ScoreEntriesTable(this);
  late final $FinishEntriesTable finishEntries = $FinishEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scoreEntries,
    finishEntries,
  ];
}

typedef $$ScoreEntriesTableCreateCompanionBuilder =
    ScoreEntriesCompanion Function({
      Value<int> id,
      required int score,
      Value<int> type,
      required DateTime timestamp,
    });
typedef $$ScoreEntriesTableUpdateCompanionBuilder =
    ScoreEntriesCompanion Function({
      Value<int> id,
      Value<int> score,
      Value<int> type,
      Value<DateTime> timestamp,
    });

class $$ScoreEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScoreEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScoreEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ScoreEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScoreEntriesTable,
          ScoreEntry,
          $$ScoreEntriesTableFilterComposer,
          $$ScoreEntriesTableOrderingComposer,
          $$ScoreEntriesTableAnnotationComposer,
          $$ScoreEntriesTableCreateCompanionBuilder,
          $$ScoreEntriesTableUpdateCompanionBuilder,
          (
            ScoreEntry,
            BaseReferences<_$AppDatabase, $ScoreEntriesTable, ScoreEntry>,
          ),
          ScoreEntry,
          PrefetchHooks Function()
        > {
  $$ScoreEntriesTableTableManager(_$AppDatabase db, $ScoreEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoreEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoreEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoreEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ScoreEntriesCompanion(
                id: id,
                score: score,
                type: type,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int score,
                Value<int> type = const Value.absent(),
                required DateTime timestamp,
              }) => ScoreEntriesCompanion.insert(
                id: id,
                score: score,
                type: type,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScoreEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScoreEntriesTable,
      ScoreEntry,
      $$ScoreEntriesTableFilterComposer,
      $$ScoreEntriesTableOrderingComposer,
      $$ScoreEntriesTableAnnotationComposer,
      $$ScoreEntriesTableCreateCompanionBuilder,
      $$ScoreEntriesTableUpdateCompanionBuilder,
      (
        ScoreEntry,
        BaseReferences<_$AppDatabase, $ScoreEntriesTable, ScoreEntry>,
      ),
      ScoreEntry,
      PrefetchHooks Function()
    >;
typedef $$FinishEntriesTableCreateCompanionBuilder =
    FinishEntriesCompanion Function({
      Value<int> id,
      required int field,
      required DateTime timestamp,
    });
typedef $$FinishEntriesTableUpdateCompanionBuilder =
    FinishEntriesCompanion Function({
      Value<int> id,
      Value<int> field,
      Value<DateTime> timestamp,
    });

class $$FinishEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FinishEntriesTable> {
  $$FinishEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinishEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishEntriesTable> {
  $$FinishEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinishEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishEntriesTable> {
  $$FinishEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get field =>
      $composableBuilder(column: $table.field, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$FinishEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishEntriesTable,
          FinishEntry,
          $$FinishEntriesTableFilterComposer,
          $$FinishEntriesTableOrderingComposer,
          $$FinishEntriesTableAnnotationComposer,
          $$FinishEntriesTableCreateCompanionBuilder,
          $$FinishEntriesTableUpdateCompanionBuilder,
          (
            FinishEntry,
            BaseReferences<_$AppDatabase, $FinishEntriesTable, FinishEntry>,
          ),
          FinishEntry,
          PrefetchHooks Function()
        > {
  $$FinishEntriesTableTableManager(_$AppDatabase db, $FinishEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinishEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> field = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => FinishEntriesCompanion(
                id: id,
                field: field,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int field,
                required DateTime timestamp,
              }) => FinishEntriesCompanion.insert(
                id: id,
                field: field,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinishEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishEntriesTable,
      FinishEntry,
      $$FinishEntriesTableFilterComposer,
      $$FinishEntriesTableOrderingComposer,
      $$FinishEntriesTableAnnotationComposer,
      $$FinishEntriesTableCreateCompanionBuilder,
      $$FinishEntriesTableUpdateCompanionBuilder,
      (
        FinishEntry,
        BaseReferences<_$AppDatabase, $FinishEntriesTable, FinishEntry>,
      ),
      FinishEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScoreEntriesTableTableManager get scoreEntries =>
      $$ScoreEntriesTableTableManager(_db, _db.scoreEntries);
  $$FinishEntriesTableTableManager get finishEntries =>
      $$FinishEntriesTableTableManager(_db, _db.finishEntries);
}
