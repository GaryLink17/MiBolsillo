// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BalanceSnapshotMetadataTable extends BalanceSnapshotMetadata
    with TableInfo<$BalanceSnapshotMetadataTable, BalanceSnapshotMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceSnapshotMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance_snapshot_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<BalanceSnapshotMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  BalanceSnapshotMetadataData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceSnapshotMetadataData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BalanceSnapshotMetadataTable createAlias(String alias) {
    return $BalanceSnapshotMetadataTable(attachedDatabase, alias);
  }
}

class BalanceSnapshotMetadataData extends DataClass
    implements Insertable<BalanceSnapshotMetadataData> {
  final String userId;

  /// Momento en que la app completó la descarga de la captura.
  final DateTime updatedAt;
  const BalanceSnapshotMetadataData({
    required this.userId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BalanceSnapshotMetadataCompanion toCompanion(bool nullToAbsent) {
    return BalanceSnapshotMetadataCompanion(
      userId: Value(userId),
      updatedAt: Value(updatedAt),
    );
  }

  factory BalanceSnapshotMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceSnapshotMetadataData(
      userId: serializer.fromJson<String>(json['userId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BalanceSnapshotMetadataData copyWith({String? userId, DateTime? updatedAt}) =>
      BalanceSnapshotMetadataData(
        userId: userId ?? this.userId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BalanceSnapshotMetadataData copyWithCompanion(
    BalanceSnapshotMetadataCompanion data,
  ) {
    return BalanceSnapshotMetadataData(
      userId: data.userId.present ? data.userId.value : this.userId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotMetadataData(')
          ..write('userId: $userId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceSnapshotMetadataData &&
          other.userId == this.userId &&
          other.updatedAt == this.updatedAt);
}

class BalanceSnapshotMetadataCompanion
    extends UpdateCompanion<BalanceSnapshotMetadataData> {
  final Value<String> userId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BalanceSnapshotMetadataCompanion({
    this.userId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BalanceSnapshotMetadataCompanion.insert({
    required String userId,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       updatedAt = Value(updatedAt);
  static Insertable<BalanceSnapshotMetadataData> custom({
    Expression<String>? userId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BalanceSnapshotMetadataCompanion copyWith({
    Value<String>? userId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BalanceSnapshotMetadataCompanion(
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotMetadataCompanion(')
          ..write('userId: $userId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAccountsTable extends CachedAccounts
    with TableInfo<$CachedAccountsTable, CachedAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    accountId,
    name,
    kind,
    balanceCents,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, accountId};
  @override
  CachedAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAccount(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CachedAccountsTable createAlias(String alias) {
    return $CachedAccountsTable(attachedDatabase, alias);
  }
}

class CachedAccount extends DataClass implements Insertable<CachedAccount> {
  final String userId;
  final String accountId;
  final String name;
  final String kind;
  final int balanceCents;
  final int sortOrder;
  const CachedAccount({
    required this.userId,
    required this.accountId,
    required this.name,
    required this.kind,
    required this.balanceCents,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['account_id'] = Variable<String>(accountId);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CachedAccountsCompanion toCompanion(bool nullToAbsent) {
    return CachedAccountsCompanion(
      userId: Value(userId),
      accountId: Value(accountId),
      name: Value(name),
      kind: Value(kind),
      balanceCents: Value(balanceCents),
      sortOrder: Value(sortOrder),
    );
  }

  factory CachedAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAccount(
      userId: serializer.fromJson<String>(json['userId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'accountId': serializer.toJson<String>(accountId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CachedAccount copyWith({
    String? userId,
    String? accountId,
    String? name,
    String? kind,
    int? balanceCents,
    int? sortOrder,
  }) => CachedAccount(
    userId: userId ?? this.userId,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    balanceCents: balanceCents ?? this.balanceCents,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CachedAccount copyWithCompanion(CachedAccountsCompanion data) {
    return CachedAccount(
      userId: data.userId.present ? data.userId.value : this.userId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAccount(')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, accountId, name, kind, balanceCents, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAccount &&
          other.userId == this.userId &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.balanceCents == this.balanceCents &&
          other.sortOrder == this.sortOrder);
}

class CachedAccountsCompanion extends UpdateCompanion<CachedAccount> {
  final Value<String> userId;
  final Value<String> accountId;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> balanceCents;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CachedAccountsCompanion({
    this.userId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAccountsCompanion.insert({
    required String userId,
    required String accountId,
    required String name,
    required String kind,
    required int balanceCents,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       accountId = Value(accountId),
       name = Value(name),
       kind = Value(kind),
       balanceCents = Value(balanceCents),
       sortOrder = Value(sortOrder);
  static Insertable<CachedAccount> custom({
    Expression<String>? userId,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? balanceCents,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAccountsCompanion copyWith({
    Value<String>? userId,
    Value<String>? accountId,
    Value<String>? name,
    Value<String>? kind,
    Value<int>? balanceCents,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CachedAccountsCompanion(
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      balanceCents: balanceCents ?? this.balanceCents,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAccountsCompanion(')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedGoalsTable extends CachedGoals
    with TableInfo<$CachedGoalsTable, CachedGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCentsMeta = const VerificationMeta(
    'targetCents',
  );
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
    'target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedCentsMeta = const VerificationMeta(
    'savedCents',
  );
  @override
  late final GeneratedColumn<int> savedCents = GeneratedColumn<int>(
    'saved_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    goalId,
    name,
    targetCents,
    savedCents,
    targetDate,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_cents')) {
      context.handle(
        _targetCentsMeta,
        targetCents.isAcceptableOrUnknown(
          data['target_cents']!,
          _targetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCentsMeta);
    }
    if (data.containsKey('saved_cents')) {
      context.handle(
        _savedCentsMeta,
        savedCents.isAcceptableOrUnknown(data['saved_cents']!, _savedCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_savedCentsMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, goalId};
  @override
  CachedGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedGoal(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cents'],
      )!,
      savedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_cents'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_date'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CachedGoalsTable createAlias(String alias) {
    return $CachedGoalsTable(attachedDatabase, alias);
  }
}

class CachedGoal extends DataClass implements Insertable<CachedGoal> {
  final String userId;
  final String goalId;
  final String name;
  final int targetCents;
  final int savedCents;

  /// Fecha civil ISO (`aaaa-mm-dd`), sin conversión de zona horaria.
  final String? targetDate;
  final int sortOrder;
  const CachedGoal({
    required this.userId,
    required this.goalId,
    required this.name,
    required this.targetCents,
    required this.savedCents,
    this.targetDate,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['goal_id'] = Variable<String>(goalId);
    map['name'] = Variable<String>(name);
    map['target_cents'] = Variable<int>(targetCents);
    map['saved_cents'] = Variable<int>(savedCents);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<String>(targetDate);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CachedGoalsCompanion toCompanion(bool nullToAbsent) {
    return CachedGoalsCompanion(
      userId: Value(userId),
      goalId: Value(goalId),
      name: Value(name),
      targetCents: Value(targetCents),
      savedCents: Value(savedCents),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      sortOrder: Value(sortOrder),
    );
  }

  factory CachedGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedGoal(
      userId: serializer.fromJson<String>(json['userId']),
      goalId: serializer.fromJson<String>(json['goalId']),
      name: serializer.fromJson<String>(json['name']),
      targetCents: serializer.fromJson<int>(json['targetCents']),
      savedCents: serializer.fromJson<int>(json['savedCents']),
      targetDate: serializer.fromJson<String?>(json['targetDate']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'goalId': serializer.toJson<String>(goalId),
      'name': serializer.toJson<String>(name),
      'targetCents': serializer.toJson<int>(targetCents),
      'savedCents': serializer.toJson<int>(savedCents),
      'targetDate': serializer.toJson<String?>(targetDate),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CachedGoal copyWith({
    String? userId,
    String? goalId,
    String? name,
    int? targetCents,
    int? savedCents,
    Value<String?> targetDate = const Value.absent(),
    int? sortOrder,
  }) => CachedGoal(
    userId: userId ?? this.userId,
    goalId: goalId ?? this.goalId,
    name: name ?? this.name,
    targetCents: targetCents ?? this.targetCents,
    savedCents: savedCents ?? this.savedCents,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CachedGoal copyWithCompanion(CachedGoalsCompanion data) {
    return CachedGoal(
      userId: data.userId.present ? data.userId.value : this.userId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      name: data.name.present ? data.name.value : this.name,
      targetCents: data.targetCents.present
          ? data.targetCents.value
          : this.targetCents,
      savedCents: data.savedCents.present
          ? data.savedCents.value
          : this.savedCents,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedGoal(')
          ..write('userId: $userId, ')
          ..write('goalId: $goalId, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('savedCents: $savedCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    goalId,
    name,
    targetCents,
    savedCents,
    targetDate,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedGoal &&
          other.userId == this.userId &&
          other.goalId == this.goalId &&
          other.name == this.name &&
          other.targetCents == this.targetCents &&
          other.savedCents == this.savedCents &&
          other.targetDate == this.targetDate &&
          other.sortOrder == this.sortOrder);
}

class CachedGoalsCompanion extends UpdateCompanion<CachedGoal> {
  final Value<String> userId;
  final Value<String> goalId;
  final Value<String> name;
  final Value<int> targetCents;
  final Value<int> savedCents;
  final Value<String?> targetDate;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CachedGoalsCompanion({
    this.userId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.savedCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedGoalsCompanion.insert({
    required String userId,
    required String goalId,
    required String name,
    required int targetCents,
    required int savedCents,
    this.targetDate = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       goalId = Value(goalId),
       name = Value(name),
       targetCents = Value(targetCents),
       savedCents = Value(savedCents),
       sortOrder = Value(sortOrder);
  static Insertable<CachedGoal> custom({
    Expression<String>? userId,
    Expression<String>? goalId,
    Expression<String>? name,
    Expression<int>? targetCents,
    Expression<int>? savedCents,
    Expression<String>? targetDate,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (goalId != null) 'goal_id': goalId,
      if (name != null) 'name': name,
      if (targetCents != null) 'target_cents': targetCents,
      if (savedCents != null) 'saved_cents': savedCents,
      if (targetDate != null) 'target_date': targetDate,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedGoalsCompanion copyWith({
    Value<String>? userId,
    Value<String>? goalId,
    Value<String>? name,
    Value<int>? targetCents,
    Value<int>? savedCents,
    Value<String?>? targetDate,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CachedGoalsCompanion(
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      name: name ?? this.name,
      targetCents: targetCents ?? this.targetCents,
      savedCents: savedCents ?? this.savedCents,
      targetDate: targetDate ?? this.targetDate,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (savedCents.present) {
      map['saved_cents'] = Variable<int>(savedCents.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<String>(targetDate.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedGoalsCompanion(')
          ..write('userId: $userId, ')
          ..write('goalId: $goalId, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('savedCents: $savedCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCategoriesTable extends CachedCategories
    with TableInfo<$CachedCategoriesTable, CachedCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toneMeta = const VerificationMeta('tone');
  @override
  late final GeneratedColumn<String> tone = GeneratedColumn<String>(
    'tone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    categoryId,
    name,
    kind,
    tone,
    icon,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('tone')) {
      context.handle(
        _toneMeta,
        tone.isAcceptableOrUnknown(data['tone']!, _toneMeta),
      );
    } else if (isInserting) {
      context.missing(_toneMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    } else if (isInserting) {
      context.missing(_isArchivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, categoryId};
  @override
  CachedCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCategory(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      tone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tone'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $CachedCategoriesTable createAlias(String alias) {
    return $CachedCategoriesTable(attachedDatabase, alias);
  }
}

class CachedCategory extends DataClass implements Insertable<CachedCategory> {
  final String userId;
  final String categoryId;
  final String name;
  final String kind;
  final String tone;
  final String icon;
  final bool isArchived;
  const CachedCategory({
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.kind,
    required this.tone,
    required this.icon,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['tone'] = Variable<String>(tone);
    map['icon'] = Variable<String>(icon);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  CachedCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CachedCategoriesCompanion(
      userId: Value(userId),
      categoryId: Value(categoryId),
      name: Value(name),
      kind: Value(kind),
      tone: Value(tone),
      icon: Value(icon),
      isArchived: Value(isArchived),
    );
  }

  factory CachedCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCategory(
      userId: serializer.fromJson<String>(json['userId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      tone: serializer.fromJson<String>(json['tone']),
      icon: serializer.fromJson<String>(json['icon']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'tone': serializer.toJson<String>(tone),
      'icon': serializer.toJson<String>(icon),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  CachedCategory copyWith({
    String? userId,
    String? categoryId,
    String? name,
    String? kind,
    String? tone,
    String? icon,
    bool? isArchived,
  }) => CachedCategory(
    userId: userId ?? this.userId,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    tone: tone ?? this.tone,
    icon: icon ?? this.icon,
    isArchived: isArchived ?? this.isArchived,
  );
  CachedCategory copyWithCompanion(CachedCategoriesCompanion data) {
    return CachedCategory(
      userId: data.userId.present ? data.userId.value : this.userId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      tone: data.tone.present ? data.tone.value : this.tone,
      icon: data.icon.present ? data.icon.value : this.icon,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCategory(')
          ..write('userId: $userId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('tone: $tone, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, categoryId, name, kind, tone, icon, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCategory &&
          other.userId == this.userId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.tone == this.tone &&
          other.icon == this.icon &&
          other.isArchived == this.isArchived);
}

class CachedCategoriesCompanion extends UpdateCompanion<CachedCategory> {
  final Value<String> userId;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String> kind;
  final Value<String> tone;
  final Value<String> icon;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const CachedCategoriesCompanion({
    this.userId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.tone = const Value.absent(),
    this.icon = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCategoriesCompanion.insert({
    required String userId,
    required String categoryId,
    required String name,
    required String kind,
    required String tone,
    required String icon,
    required bool isArchived,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       categoryId = Value(categoryId),
       name = Value(name),
       kind = Value(kind),
       tone = Value(tone),
       icon = Value(icon),
       isArchived = Value(isArchived);
  static Insertable<CachedCategory> custom({
    Expression<String>? userId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? tone,
    Expression<String>? icon,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (tone != null) 'tone': tone,
      if (icon != null) 'icon': icon,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCategoriesCompanion copyWith({
    Value<String>? userId,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String>? kind,
    Value<String>? tone,
    Value<String>? icon,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return CachedCategoriesCompanion(
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      tone: tone ?? this.tone,
      icon: icon ?? this.icon,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (tone.present) {
      map['tone'] = Variable<String>(tone.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCategoriesCompanion(')
          ..write('userId: $userId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('tone: $tone, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMovementsTable extends CachedMovements
    with TableInfo<$CachedMovementsTable, CachedMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementIdMeta = const VerificationMeta(
    'movementId',
  );
  @override
  late final GeneratedColumn<String> movementId = GeneratedColumn<String>(
    'movement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredOnMeta = const VerificationMeta(
    'occurredOn',
  );
  @override
  late final GeneratedColumn<String> occurredOn = GeneratedColumn<String>(
    'occurred_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalNameMeta = const VerificationMeta(
    'goalName',
  );
  @override
  late final GeneratedColumn<String> goalName = GeneratedColumn<String>(
    'goal_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    movementId,
    type,
    amountCents,
    occurredOn,
    accountId,
    accountName,
    categoryId,
    goalId,
    goalName,
    note,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('movement_id')) {
      context.handle(
        _movementIdMeta,
        movementId.isAcceptableOrUnknown(data['movement_id']!, _movementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movementIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('occurred_on')) {
      context.handle(
        _occurredOnMeta,
        occurredOn.isAcceptableOrUnknown(data['occurred_on']!, _occurredOnMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredOnMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('goal_name')) {
      context.handle(
        _goalNameMeta,
        goalName.isAcceptableOrUnknown(data['goal_name']!, _goalNameMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, movementId};
  @override
  CachedMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMovement(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      movementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      occurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_on'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      goalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CachedMovementsTable createAlias(String alias) {
    return $CachedMovementsTable(attachedDatabase, alias);
  }
}

class CachedMovement extends DataClass implements Insertable<CachedMovement> {
  final String userId;
  final String movementId;
  final String type;
  final int amountCents;

  /// Fecha civil ISO (`aaaa-mm-dd`), sin hora ni zona horaria.
  final String occurredOn;
  final String accountId;
  final String? accountName;
  final String? categoryId;
  final String? goalId;
  final String? goalName;
  final String? note;

  /// Orden entregado por la descarga, incluidos empates de fecha.
  final int sortOrder;
  const CachedMovement({
    required this.userId,
    required this.movementId,
    required this.type,
    required this.amountCents,
    required this.occurredOn,
    required this.accountId,
    this.accountName,
    this.categoryId,
    this.goalId,
    this.goalName,
    this.note,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['movement_id'] = Variable<String>(movementId);
    map['type'] = Variable<String>(type);
    map['amount_cents'] = Variable<int>(amountCents);
    map['occurred_on'] = Variable<String>(occurredOn);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || accountName != null) {
      map['account_name'] = Variable<String>(accountName);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || goalName != null) {
      map['goal_name'] = Variable<String>(goalName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CachedMovementsCompanion toCompanion(bool nullToAbsent) {
    return CachedMovementsCompanion(
      userId: Value(userId),
      movementId: Value(movementId),
      type: Value(type),
      amountCents: Value(amountCents),
      occurredOn: Value(occurredOn),
      accountId: Value(accountId),
      accountName: accountName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      goalName: goalName == null && nullToAbsent
          ? const Value.absent()
          : Value(goalName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      sortOrder: Value(sortOrder),
    );
  }

  factory CachedMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMovement(
      userId: serializer.fromJson<String>(json['userId']),
      movementId: serializer.fromJson<String>(json['movementId']),
      type: serializer.fromJson<String>(json['type']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      occurredOn: serializer.fromJson<String>(json['occurredOn']),
      accountId: serializer.fromJson<String>(json['accountId']),
      accountName: serializer.fromJson<String?>(json['accountName']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      goalName: serializer.fromJson<String?>(json['goalName']),
      note: serializer.fromJson<String?>(json['note']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'movementId': serializer.toJson<String>(movementId),
      'type': serializer.toJson<String>(type),
      'amountCents': serializer.toJson<int>(amountCents),
      'occurredOn': serializer.toJson<String>(occurredOn),
      'accountId': serializer.toJson<String>(accountId),
      'accountName': serializer.toJson<String?>(accountName),
      'categoryId': serializer.toJson<String?>(categoryId),
      'goalId': serializer.toJson<String?>(goalId),
      'goalName': serializer.toJson<String?>(goalName),
      'note': serializer.toJson<String?>(note),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CachedMovement copyWith({
    String? userId,
    String? movementId,
    String? type,
    int? amountCents,
    String? occurredOn,
    String? accountId,
    Value<String?> accountName = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    Value<String?> goalName = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? sortOrder,
  }) => CachedMovement(
    userId: userId ?? this.userId,
    movementId: movementId ?? this.movementId,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    occurredOn: occurredOn ?? this.occurredOn,
    accountId: accountId ?? this.accountId,
    accountName: accountName.present ? accountName.value : this.accountName,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    goalId: goalId.present ? goalId.value : this.goalId,
    goalName: goalName.present ? goalName.value : this.goalName,
    note: note.present ? note.value : this.note,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CachedMovement copyWithCompanion(CachedMovementsCompanion data) {
    return CachedMovement(
      userId: data.userId.present ? data.userId.value : this.userId,
      movementId: data.movementId.present
          ? data.movementId.value
          : this.movementId,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      occurredOn: data.occurredOn.present
          ? data.occurredOn.value
          : this.occurredOn,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      goalName: data.goalName.present ? data.goalName.value : this.goalName,
      note: data.note.present ? data.note.value : this.note,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMovement(')
          ..write('userId: $userId, ')
          ..write('movementId: $movementId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('categoryId: $categoryId, ')
          ..write('goalId: $goalId, ')
          ..write('goalName: $goalName, ')
          ..write('note: $note, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    movementId,
    type,
    amountCents,
    occurredOn,
    accountId,
    accountName,
    categoryId,
    goalId,
    goalName,
    note,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMovement &&
          other.userId == this.userId &&
          other.movementId == this.movementId &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.occurredOn == this.occurredOn &&
          other.accountId == this.accountId &&
          other.accountName == this.accountName &&
          other.categoryId == this.categoryId &&
          other.goalId == this.goalId &&
          other.goalName == this.goalName &&
          other.note == this.note &&
          other.sortOrder == this.sortOrder);
}

class CachedMovementsCompanion extends UpdateCompanion<CachedMovement> {
  final Value<String> userId;
  final Value<String> movementId;
  final Value<String> type;
  final Value<int> amountCents;
  final Value<String> occurredOn;
  final Value<String> accountId;
  final Value<String?> accountName;
  final Value<String?> categoryId;
  final Value<String?> goalId;
  final Value<String?> goalName;
  final Value<String?> note;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CachedMovementsCompanion({
    this.userId = const Value.absent(),
    this.movementId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.occurredOn = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.goalName = const Value.absent(),
    this.note = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMovementsCompanion.insert({
    required String userId,
    required String movementId,
    required String type,
    required int amountCents,
    required String occurredOn,
    required String accountId,
    this.accountName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.goalName = const Value.absent(),
    this.note = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       movementId = Value(movementId),
       type = Value(type),
       amountCents = Value(amountCents),
       occurredOn = Value(occurredOn),
       accountId = Value(accountId),
       sortOrder = Value(sortOrder);
  static Insertable<CachedMovement> custom({
    Expression<String>? userId,
    Expression<String>? movementId,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<String>? occurredOn,
    Expression<String>? accountId,
    Expression<String>? accountName,
    Expression<String>? categoryId,
    Expression<String>? goalId,
    Expression<String>? goalName,
    Expression<String>? note,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (movementId != null) 'movement_id': movementId,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (occurredOn != null) 'occurred_on': occurredOn,
      if (accountId != null) 'account_id': accountId,
      if (accountName != null) 'account_name': accountName,
      if (categoryId != null) 'category_id': categoryId,
      if (goalId != null) 'goal_id': goalId,
      if (goalName != null) 'goal_name': goalName,
      if (note != null) 'note': note,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMovementsCompanion copyWith({
    Value<String>? userId,
    Value<String>? movementId,
    Value<String>? type,
    Value<int>? amountCents,
    Value<String>? occurredOn,
    Value<String>? accountId,
    Value<String?>? accountName,
    Value<String?>? categoryId,
    Value<String?>? goalId,
    Value<String?>? goalName,
    Value<String?>? note,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CachedMovementsCompanion(
      userId: userId ?? this.userId,
      movementId: movementId ?? this.movementId,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      occurredOn: occurredOn ?? this.occurredOn,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      categoryId: categoryId ?? this.categoryId,
      goalId: goalId ?? this.goalId,
      goalName: goalName ?? this.goalName,
      note: note ?? this.note,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (movementId.present) {
      map['movement_id'] = Variable<String>(movementId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (occurredOn.present) {
      map['occurred_on'] = Variable<String>(occurredOn.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (goalName.present) {
      map['goal_name'] = Variable<String>(goalName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMovementsCompanion(')
          ..write('userId: $userId, ')
          ..write('movementId: $movementId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('categoryId: $categoryId, ')
          ..write('goalId: $goalId, ')
          ..write('goalName: $goalName, ')
          ..write('note: $note, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedDatasetMetadataTable extends CachedDatasetMetadata
    with TableInfo<$CachedDatasetMetadataTable, CachedDatasetMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDatasetMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasetMeta = const VerificationMeta(
    'dataset',
  );
  @override
  late final GeneratedColumn<String> dataset = GeneratedColumn<String>(
    'dataset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, dataset, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_dataset_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDatasetMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('dataset')) {
      context.handle(
        _datasetMeta,
        dataset.isAcceptableOrUnknown(data['dataset']!, _datasetMeta),
      );
    } else if (isInserting) {
      context.missing(_datasetMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, dataset};
  @override
  CachedDatasetMetadataData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDatasetMetadataData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      dataset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dataset'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedDatasetMetadataTable createAlias(String alias) {
    return $CachedDatasetMetadataTable(attachedDatabase, alias);
  }
}

class CachedDatasetMetadataData extends DataClass
    implements Insertable<CachedDatasetMetadataData> {
  final String userId;
  final String dataset;
  final DateTime updatedAt;
  const CachedDatasetMetadataData({
    required this.userId,
    required this.dataset,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['dataset'] = Variable<String>(dataset);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedDatasetMetadataCompanion toCompanion(bool nullToAbsent) {
    return CachedDatasetMetadataCompanion(
      userId: Value(userId),
      dataset: Value(dataset),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedDatasetMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDatasetMetadataData(
      userId: serializer.fromJson<String>(json['userId']),
      dataset: serializer.fromJson<String>(json['dataset']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'dataset': serializer.toJson<String>(dataset),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedDatasetMetadataData copyWith({
    String? userId,
    String? dataset,
    DateTime? updatedAt,
  }) => CachedDatasetMetadataData(
    userId: userId ?? this.userId,
    dataset: dataset ?? this.dataset,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedDatasetMetadataData copyWithCompanion(
    CachedDatasetMetadataCompanion data,
  ) {
    return CachedDatasetMetadataData(
      userId: data.userId.present ? data.userId.value : this.userId,
      dataset: data.dataset.present ? data.dataset.value : this.dataset,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDatasetMetadataData(')
          ..write('userId: $userId, ')
          ..write('dataset: $dataset, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, dataset, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDatasetMetadataData &&
          other.userId == this.userId &&
          other.dataset == this.dataset &&
          other.updatedAt == this.updatedAt);
}

class CachedDatasetMetadataCompanion
    extends UpdateCompanion<CachedDatasetMetadataData> {
  final Value<String> userId;
  final Value<String> dataset;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedDatasetMetadataCompanion({
    this.userId = const Value.absent(),
    this.dataset = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDatasetMetadataCompanion.insert({
    required String userId,
    required String dataset,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       dataset = Value(dataset),
       updatedAt = Value(updatedAt);
  static Insertable<CachedDatasetMetadataData> custom({
    Expression<String>? userId,
    Expression<String>? dataset,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (dataset != null) 'dataset': dataset,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDatasetMetadataCompanion copyWith({
    Value<String>? userId,
    Value<String>? dataset,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedDatasetMetadataCompanion(
      userId: userId ?? this.userId,
      dataset: dataset ?? this.dataset,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (dataset.present) {
      map['dataset'] = Variable<String>(dataset.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDatasetMetadataCompanion(')
          ..write('userId: $userId, ')
          ..write('dataset: $dataset, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BalanceSnapshotMetadataTable balanceSnapshotMetadata =
      $BalanceSnapshotMetadataTable(this);
  late final $CachedAccountsTable cachedAccounts = $CachedAccountsTable(this);
  late final $CachedGoalsTable cachedGoals = $CachedGoalsTable(this);
  late final $CachedCategoriesTable cachedCategories = $CachedCategoriesTable(
    this,
  );
  late final $CachedMovementsTable cachedMovements = $CachedMovementsTable(
    this,
  );
  late final $CachedDatasetMetadataTable cachedDatasetMetadata =
      $CachedDatasetMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    balanceSnapshotMetadata,
    cachedAccounts,
    cachedGoals,
    cachedCategories,
    cachedMovements,
    cachedDatasetMetadata,
  ];
}

typedef $$BalanceSnapshotMetadataTableCreateCompanionBuilder =
    BalanceSnapshotMetadataCompanion Function({
      required String userId,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BalanceSnapshotMetadataTableUpdateCompanionBuilder =
    BalanceSnapshotMetadataCompanion Function({
      Value<String> userId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BalanceSnapshotMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotMetadataTable> {
  $$BalanceSnapshotMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BalanceSnapshotMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotMetadataTable> {
  $$BalanceSnapshotMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BalanceSnapshotMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotMetadataTable> {
  $$BalanceSnapshotMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BalanceSnapshotMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BalanceSnapshotMetadataTable,
          BalanceSnapshotMetadataData,
          $$BalanceSnapshotMetadataTableFilterComposer,
          $$BalanceSnapshotMetadataTableOrderingComposer,
          $$BalanceSnapshotMetadataTableAnnotationComposer,
          $$BalanceSnapshotMetadataTableCreateCompanionBuilder,
          $$BalanceSnapshotMetadataTableUpdateCompanionBuilder,
          (
            BalanceSnapshotMetadataData,
            BaseReferences<
              _$AppDatabase,
              $BalanceSnapshotMetadataTable,
              BalanceSnapshotMetadataData
            >,
          ),
          BalanceSnapshotMetadataData,
          PrefetchHooks Function()
        > {
  $$BalanceSnapshotMetadataTableTableManager(
    _$AppDatabase db,
    $BalanceSnapshotMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceSnapshotMetadataTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BalanceSnapshotMetadataTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BalanceSnapshotMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BalanceSnapshotMetadataCompanion(
                userId: userId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BalanceSnapshotMetadataCompanion.insert(
                userId: userId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $BalanceSnapshotMetadataTable,
                    BalanceSnapshotMetadataData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BalanceSnapshotMetadataTable,
                    BalanceSnapshotMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BalanceSnapshotMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BalanceSnapshotMetadataTable,
      BalanceSnapshotMetadataData,
      $$BalanceSnapshotMetadataTableFilterComposer,
      $$BalanceSnapshotMetadataTableOrderingComposer,
      $$BalanceSnapshotMetadataTableAnnotationComposer,
      $$BalanceSnapshotMetadataTableCreateCompanionBuilder,
      $$BalanceSnapshotMetadataTableUpdateCompanionBuilder,
      (
        BalanceSnapshotMetadataData,
        BaseReferences<
          _$AppDatabase,
          $BalanceSnapshotMetadataTable,
          BalanceSnapshotMetadataData
        >,
      ),
      BalanceSnapshotMetadataData,
      PrefetchHooks Function()
    >;
typedef $$CachedAccountsTableCreateCompanionBuilder =
    CachedAccountsCompanion Function({
      required String userId,
      required String accountId,
      required String name,
      required String kind,
      required int balanceCents,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$CachedAccountsTableUpdateCompanionBuilder =
    CachedAccountsCompanion Function({
      Value<String> userId,
      Value<String> accountId,
      Value<String> name,
      Value<String> kind,
      Value<int> balanceCents,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$CachedAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CachedAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAccountsTable,
          CachedAccount,
          $$CachedAccountsTableFilterComposer,
          $$CachedAccountsTableOrderingComposer,
          $$CachedAccountsTableAnnotationComposer,
          $$CachedAccountsTableCreateCompanionBuilder,
          $$CachedAccountsTableUpdateCompanionBuilder,
          (
            CachedAccount,
            BaseReferences<_$AppDatabase, $CachedAccountsTable, CachedAccount>,
          ),
          CachedAccount,
          PrefetchHooks Function()
        > {
  $$CachedAccountsTableTableManager(
    _$AppDatabase db,
    $CachedAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAccountsCompanion(
                userId: userId,
                accountId: accountId,
                name: name,
                kind: kind,
                balanceCents: balanceCents,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String accountId,
                required String name,
                required String kind,
                required int balanceCents,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CachedAccountsCompanion.insert(
                userId: userId,
                accountId: accountId,
                name: name,
                kind: kind,
                balanceCents: balanceCents,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedAccountsTable, CachedAccount>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedAccountsTable,
                    CachedAccount
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAccountsTable,
      CachedAccount,
      $$CachedAccountsTableFilterComposer,
      $$CachedAccountsTableOrderingComposer,
      $$CachedAccountsTableAnnotationComposer,
      $$CachedAccountsTableCreateCompanionBuilder,
      $$CachedAccountsTableUpdateCompanionBuilder,
      (
        CachedAccount,
        BaseReferences<_$AppDatabase, $CachedAccountsTable, CachedAccount>,
      ),
      CachedAccount,
      PrefetchHooks Function()
    >;
typedef $$CachedGoalsTableCreateCompanionBuilder =
    CachedGoalsCompanion Function({
      required String userId,
      required String goalId,
      required String name,
      required int targetCents,
      required int savedCents,
      Value<String?> targetDate,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$CachedGoalsTableUpdateCompanionBuilder =
    CachedGoalsCompanion Function({
      Value<String> userId,
      Value<String> goalId,
      Value<String> name,
      Value<int> targetCents,
      Value<int> savedCents,
      Value<String?> targetDate,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$CachedGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedGoalsTable> {
  $$CachedGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedGoalsTable> {
  $$CachedGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedGoalsTable> {
  $$CachedGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CachedGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedGoalsTable,
          CachedGoal,
          $$CachedGoalsTableFilterComposer,
          $$CachedGoalsTableOrderingComposer,
          $$CachedGoalsTableAnnotationComposer,
          $$CachedGoalsTableCreateCompanionBuilder,
          $$CachedGoalsTableUpdateCompanionBuilder,
          (
            CachedGoal,
            BaseReferences<_$AppDatabase, $CachedGoalsTable, CachedGoal>,
          ),
          CachedGoal,
          PrefetchHooks Function()
        > {
  $$CachedGoalsTableTableManager(_$AppDatabase db, $CachedGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetCents = const Value.absent(),
                Value<int> savedCents = const Value.absent(),
                Value<String?> targetDate = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGoalsCompanion(
                userId: userId,
                goalId: goalId,
                name: name,
                targetCents: targetCents,
                savedCents: savedCents,
                targetDate: targetDate,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String goalId,
                required String name,
                required int targetCents,
                required int savedCents,
                Value<String?> targetDate = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CachedGoalsCompanion.insert(
                userId: userId,
                goalId: goalId,
                name: name,
                targetCents: targetCents,
                savedCents: savedCents,
                targetDate: targetDate,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedGoalsTable, CachedGoal>(table),
                  BaseReferences<_$AppDatabase, $CachedGoalsTable, CachedGoal>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedGoalsTable,
      CachedGoal,
      $$CachedGoalsTableFilterComposer,
      $$CachedGoalsTableOrderingComposer,
      $$CachedGoalsTableAnnotationComposer,
      $$CachedGoalsTableCreateCompanionBuilder,
      $$CachedGoalsTableUpdateCompanionBuilder,
      (
        CachedGoal,
        BaseReferences<_$AppDatabase, $CachedGoalsTable, CachedGoal>,
      ),
      CachedGoal,
      PrefetchHooks Function()
    >;
typedef $$CachedCategoriesTableCreateCompanionBuilder =
    CachedCategoriesCompanion Function({
      required String userId,
      required String categoryId,
      required String name,
      required String kind,
      required String tone,
      required String icon,
      required bool isArchived,
      Value<int> rowid,
    });
typedef $$CachedCategoriesTableUpdateCompanionBuilder =
    CachedCategoriesCompanion Function({
      Value<String> userId,
      Value<String> categoryId,
      Value<String> name,
      Value<String> kind,
      Value<String> tone,
      Value<String> icon,
      Value<bool> isArchived,
      Value<int> rowid,
    });

class $$CachedCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tone => $composableBuilder(
    column: $table.tone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tone => $composableBuilder(
    column: $table.tone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCategoriesTable> {
  $$CachedCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get tone =>
      $composableBuilder(column: $table.tone, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$CachedCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCategoriesTable,
          CachedCategory,
          $$CachedCategoriesTableFilterComposer,
          $$CachedCategoriesTableOrderingComposer,
          $$CachedCategoriesTableAnnotationComposer,
          $$CachedCategoriesTableCreateCompanionBuilder,
          $$CachedCategoriesTableUpdateCompanionBuilder,
          (
            CachedCategory,
            BaseReferences<
              _$AppDatabase,
              $CachedCategoriesTable,
              CachedCategory
            >,
          ),
          CachedCategory,
          PrefetchHooks Function()
        > {
  $$CachedCategoriesTableTableManager(
    _$AppDatabase db,
    $CachedCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> tone = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCategoriesCompanion(
                userId: userId,
                categoryId: categoryId,
                name: name,
                kind: kind,
                tone: tone,
                icon: icon,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String categoryId,
                required String name,
                required String kind,
                required String tone,
                required String icon,
                required bool isArchived,
                Value<int> rowid = const Value.absent(),
              }) => CachedCategoriesCompanion.insert(
                userId: userId,
                categoryId: categoryId,
                name: name,
                kind: kind,
                tone: tone,
                icon: icon,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedCategoriesTable, CachedCategory>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedCategoriesTable,
                    CachedCategory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCategoriesTable,
      CachedCategory,
      $$CachedCategoriesTableFilterComposer,
      $$CachedCategoriesTableOrderingComposer,
      $$CachedCategoriesTableAnnotationComposer,
      $$CachedCategoriesTableCreateCompanionBuilder,
      $$CachedCategoriesTableUpdateCompanionBuilder,
      (
        CachedCategory,
        BaseReferences<_$AppDatabase, $CachedCategoriesTable, CachedCategory>,
      ),
      CachedCategory,
      PrefetchHooks Function()
    >;
typedef $$CachedMovementsTableCreateCompanionBuilder =
    CachedMovementsCompanion Function({
      required String userId,
      required String movementId,
      required String type,
      required int amountCents,
      required String occurredOn,
      required String accountId,
      Value<String?> accountName,
      Value<String?> categoryId,
      Value<String?> goalId,
      Value<String?> goalName,
      Value<String?> note,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$CachedMovementsTableUpdateCompanionBuilder =
    CachedMovementsCompanion Function({
      Value<String> userId,
      Value<String> movementId,
      Value<String> type,
      Value<int> amountCents,
      Value<String> occurredOn,
      Value<String> accountId,
      Value<String?> accountName,
      Value<String?> categoryId,
      Value<String?> goalId,
      Value<String?> goalName,
      Value<String?> note,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$CachedMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMovementsTable> {
  $$CachedMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementId => $composableBuilder(
    column: $table.movementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalName => $composableBuilder(
    column: $table.goalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMovementsTable> {
  $$CachedMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementId => $composableBuilder(
    column: $table.movementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalName => $composableBuilder(
    column: $table.goalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMovementsTable> {
  $$CachedMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get movementId => $composableBuilder(
    column: $table.movementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get goalName =>
      $composableBuilder(column: $table.goalName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CachedMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMovementsTable,
          CachedMovement,
          $$CachedMovementsTableFilterComposer,
          $$CachedMovementsTableOrderingComposer,
          $$CachedMovementsTableAnnotationComposer,
          $$CachedMovementsTableCreateCompanionBuilder,
          $$CachedMovementsTableUpdateCompanionBuilder,
          (
            CachedMovement,
            BaseReferences<
              _$AppDatabase,
              $CachedMovementsTable,
              CachedMovement
            >,
          ),
          CachedMovement,
          PrefetchHooks Function()
        > {
  $$CachedMovementsTableTableManager(
    _$AppDatabase db,
    $CachedMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> movementId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> occurredOn = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> goalName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMovementsCompanion(
                userId: userId,
                movementId: movementId,
                type: type,
                amountCents: amountCents,
                occurredOn: occurredOn,
                accountId: accountId,
                accountName: accountName,
                categoryId: categoryId,
                goalId: goalId,
                goalName: goalName,
                note: note,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String movementId,
                required String type,
                required int amountCents,
                required String occurredOn,
                required String accountId,
                Value<String?> accountName = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> goalName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => CachedMovementsCompanion.insert(
                userId: userId,
                movementId: movementId,
                type: type,
                amountCents: amountCents,
                occurredOn: occurredOn,
                accountId: accountId,
                accountName: accountName,
                categoryId: categoryId,
                goalId: goalId,
                goalName: goalName,
                note: note,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedMovementsTable, CachedMovement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedMovementsTable,
                    CachedMovement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMovementsTable,
      CachedMovement,
      $$CachedMovementsTableFilterComposer,
      $$CachedMovementsTableOrderingComposer,
      $$CachedMovementsTableAnnotationComposer,
      $$CachedMovementsTableCreateCompanionBuilder,
      $$CachedMovementsTableUpdateCompanionBuilder,
      (
        CachedMovement,
        BaseReferences<_$AppDatabase, $CachedMovementsTable, CachedMovement>,
      ),
      CachedMovement,
      PrefetchHooks Function()
    >;
typedef $$CachedDatasetMetadataTableCreateCompanionBuilder =
    CachedDatasetMetadataCompanion Function({
      required String userId,
      required String dataset,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedDatasetMetadataTableUpdateCompanionBuilder =
    CachedDatasetMetadataCompanion Function({
      Value<String> userId,
      Value<String> dataset,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedDatasetMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $CachedDatasetMetadataTable> {
  $$CachedDatasetMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataset => $composableBuilder(
    column: $table.dataset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDatasetMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedDatasetMetadataTable> {
  $$CachedDatasetMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataset => $composableBuilder(
    column: $table.dataset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDatasetMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedDatasetMetadataTable> {
  $$CachedDatasetMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get dataset =>
      $composableBuilder(column: $table.dataset, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedDatasetMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedDatasetMetadataTable,
          CachedDatasetMetadataData,
          $$CachedDatasetMetadataTableFilterComposer,
          $$CachedDatasetMetadataTableOrderingComposer,
          $$CachedDatasetMetadataTableAnnotationComposer,
          $$CachedDatasetMetadataTableCreateCompanionBuilder,
          $$CachedDatasetMetadataTableUpdateCompanionBuilder,
          (
            CachedDatasetMetadataData,
            BaseReferences<
              _$AppDatabase,
              $CachedDatasetMetadataTable,
              CachedDatasetMetadataData
            >,
          ),
          CachedDatasetMetadataData,
          PrefetchHooks Function()
        > {
  $$CachedDatasetMetadataTableTableManager(
    _$AppDatabase db,
    $CachedDatasetMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDatasetMetadataTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedDatasetMetadataTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedDatasetMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> dataset = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDatasetMetadataCompanion(
                userId: userId,
                dataset: dataset,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String dataset,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedDatasetMetadataCompanion.insert(
                userId: userId,
                dataset: dataset,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CachedDatasetMetadataTable,
                    CachedDatasetMetadataData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedDatasetMetadataTable,
                    CachedDatasetMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDatasetMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedDatasetMetadataTable,
      CachedDatasetMetadataData,
      $$CachedDatasetMetadataTableFilterComposer,
      $$CachedDatasetMetadataTableOrderingComposer,
      $$CachedDatasetMetadataTableAnnotationComposer,
      $$CachedDatasetMetadataTableCreateCompanionBuilder,
      $$CachedDatasetMetadataTableUpdateCompanionBuilder,
      (
        CachedDatasetMetadataData,
        BaseReferences<
          _$AppDatabase,
          $CachedDatasetMetadataTable,
          CachedDatasetMetadataData
        >,
      ),
      CachedDatasetMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BalanceSnapshotMetadataTableTableManager get balanceSnapshotMetadata =>
      $$BalanceSnapshotMetadataTableTableManager(
        _db,
        _db.balanceSnapshotMetadata,
      );
  $$CachedAccountsTableTableManager get cachedAccounts =>
      $$CachedAccountsTableTableManager(_db, _db.cachedAccounts);
  $$CachedGoalsTableTableManager get cachedGoals =>
      $$CachedGoalsTableTableManager(_db, _db.cachedGoals);
  $$CachedCategoriesTableTableManager get cachedCategories =>
      $$CachedCategoriesTableTableManager(_db, _db.cachedCategories);
  $$CachedMovementsTableTableManager get cachedMovements =>
      $$CachedMovementsTableTableManager(_db, _db.cachedMovements);
  $$CachedDatasetMetadataTableTableManager get cachedDatasetMetadata =>
      $$CachedDatasetMetadataTableTableManager(_db, _db.cachedDatasetMetadata);
}
