// Archivo: test/app_database_test.dart
//
// Comprueba la estructura inicial de Drift sin crear archivos ni datos reales.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/core/database/app_database.dart';

void main() {
  test('abre y cierra una base temporal en memoria', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final result = await database.customSelect('SELECT 1 AS value').getSingle();
    expect(result.read<int>('value'), 1);
    expect(database.schemaVersion, 1);
    expect(database.allTables, hasLength(6));
  });

  test('guarda la fecha de la captura de cada usuario en memoria', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final updatedAt = DateTime.utc(2026, 11, 12, 10);

    expect(
      await database.select(database.balanceSnapshotMetadata).get(),
      isEmpty,
    );
    await database
        .into(database.balanceSnapshotMetadata)
        .insert(
          BalanceSnapshotMetadataCompanion.insert(
            userId: 'usuario-1',
            updatedAt: updatedAt,
          ),
        );
    final row = await database
        .select(database.balanceSnapshotMetadata)
        .getSingle();
    expect(row.userId, 'usuario-1');
    expect(row.updatedAt.toUtc(), updatedAt);
  });

  test('guarda cuentas por usuario con saldo en centavos y orden', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database
        .into(database.cachedAccounts)
        .insert(
          CachedAccountsCompanion.insert(
            userId: 'usuario-1',
            accountId: 'cuenta-1',
            name: 'Banco',
            kind: 'banco',
            balanceCents: -2550,
            sortOrder: 0,
          ),
        );
    await database
        .into(database.cachedAccounts)
        .insert(
          CachedAccountsCompanion.insert(
            userId: 'usuario-2',
            accountId: 'cuenta-1',
            name: 'Efectivo',
            kind: 'efectivo',
            balanceCents: 10000,
            sortOrder: 1,
          ),
        );

    final rows = await (database.select(
      database.cachedAccounts,
    )..where((account) => account.userId.equals('usuario-1'))).get();
    expect(rows, hasLength(1));
    expect(rows.single.accountId, 'cuenta-1');
    expect(rows.single.name, 'Banco');
    expect(rows.single.kind, 'banco');
    expect(rows.single.balanceCents, -2550);
    expect(rows.single.sortOrder, 0);
  });

  test(
    'guarda metas, categorías y movimientos separados por usuario',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      for (final user in ['usuario-1', 'usuario-2']) {
        await db
            .into(db.cachedGoals)
            .insert(
              CachedGoalsCompanion.insert(
                userId: user,
                goalId: 'meta',
                name: 'Meta $user',
                targetCents: 123456,
                savedCents: 2550,
                targetDate: const Value('2027-03-15'),
                sortOrder: 0,
              ),
            );
        await db
            .into(db.cachedCategories)
            .insert(
              CachedCategoriesCompanion.insert(
                userId: user,
                categoryId: 'categoria',
                name: 'Categoría $user',
                kind: 'gasto',
                tone: 'food',
                icon: 'restaurant',
                isArchived: false,
              ),
            );
        await db
            .into(db.cachedMovements)
            .insert(
              CachedMovementsCompanion.insert(
                userId: user,
                movementId: 'movimiento',
                type: 'ahorro',
                amountCents: 2550,
                occurredOn: '2026-11-13',
                accountId: 'cuenta',
                accountName: const Value('Banco'),
                goalId: const Value('meta'),
                goalName: Value('Meta $user'),
                note: const Value('Mensual'),
                sortOrder: 0,
              ),
            );
        await db
            .into(db.cachedDatasetMetadata)
            .insert(
              CachedDatasetMetadataCompanion.insert(
                userId: user,
                dataset: 'movements',
                updatedAt: DateTime.utc(2026, 11, 13),
              ),
            );
      }

      final goals = await (db.select(
        db.cachedGoals,
      )..where((row) => row.userId.equals('usuario-1'))).get();
      final categories = await (db.select(
        db.cachedCategories,
      )..where((row) => row.userId.equals('usuario-1'))).get();
      final movements = await (db.select(
        db.cachedMovements,
      )..where((row) => row.userId.equals('usuario-1'))).get();
      final metadata = await (db.select(
        db.cachedDatasetMetadata,
      )..where((row) => row.userId.equals('usuario-1'))).get();
      expect(goals.single.name, 'Meta usuario-1');
      expect(goals.single.targetCents, 123456);
      expect(goals.single.savedCents, 2550);
      expect(goals.single.targetDate, '2027-03-15');
      expect(categories.single.name, 'Categoría usuario-1');
      expect(categories.single.icon, 'restaurant');
      expect(movements.single.goalName, 'Meta usuario-1');
      expect(movements.single.amountCents, 2550);
      expect(movements.single.occurredOn, '2026-11-13');
      expect(metadata.single.dataset, 'movements');
    },
  );
}
