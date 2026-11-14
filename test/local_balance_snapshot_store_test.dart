// Archivo: test/local_balance_snapshot_store_test.dart
//
// Pruebas de capturas completas, aislamiento y recuperación ante fallos.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/core/database/app_database.dart';
import 'package:mibolsillo/features/balances/data/local_balance_snapshot_store.dart';

CachedAccount account(String user, String id, int cents, {int order = 0}) =>
    CachedAccount(
      userId: user,
      accountId: id,
      name: id,
      kind: 'banco',
      balanceCents: cents,
      sortOrder: order,
    );

CachedGoal goal(String user, String id) => CachedGoal(
  userId: user,
  goalId: id,
  name: id,
  targetCents: 10000,
  savedCents: 500,
  targetDate: '2027-03-15',
  sortOrder: 0,
);

LocalBalanceSnapshot snapshot(
  String user, {
  List<CachedAccount> accounts = const [],
  List<CachedGoal> goals = const [],
  DateTime? time,
}) => LocalBalanceSnapshot(
  userId: user,
  updatedAt: time ?? DateTime.utc(2026, 11, 13),
  accounts: accounts,
  goals: goals,
);

void main() {
  test('distingue captura ausente de captura descargada vacía', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = LocalBalanceSnapshotStore(db);
    expect(await store.read('u1'), isNull);
    await store.replace(snapshot('u1'));
    final saved = await store.read('u1');
    expect(saved, isNotNull);
    expect(saved!.accounts, isEmpty);
    expect(saved.goals, isEmpty);
    expect(saved.updatedAt.toUtc(), DateTime.utc(2026, 11, 13));
  });

  test('reemplaza una captura sin afectar a otro usuario', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = LocalBalanceSnapshotStore(db);
    await store.replace(
      snapshot(
        'u1',
        accounts: [account('u1', 'antigua', 10)],
        goals: [goal('u1', 'vieja')],
      ),
    );
    await store.replace(snapshot('u2', accounts: [account('u2', 'otra', 99)]));
    await store.replace(
      snapshot(
        'u1',
        accounts: [
          account('u1', 'b', -2550, order: 1),
          account('u1', 'a', 500, order: 0),
        ],
        goals: [goal('u1', 'nueva')],
      ),
    );
    final saved = (await store.read('u1'))!;
    expect(saved.accounts.map((item) => item.accountId), ['a', 'b']);
    expect(saved.accounts.last.balanceCents, -2550);
    expect(saved.goals.single.goalId, 'nueva');
    expect(saved.goals.single.targetDate, '2027-03-15');
    expect((await store.read('u2'))!.accounts.single.balanceCents, 99);
  });

  test('un fallo de inserción revierte cuentas, metas y fecha', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = LocalBalanceSnapshotStore(db);
    final originalTime = DateTime.utc(2026, 11, 13);
    await store.replace(
      snapshot(
        'u1',
        time: originalTime,
        accounts: [account('u1', 'original', 123)],
        goals: [goal('u1', 'meta')],
      ),
    );
    await expectLater(
      store.replace(
        snapshot(
          'u1',
          time: DateTime.utc(2026, 11, 14),
          accounts: [account('u1', 'nueva', 1)],
          goals: [goal('u1', 'duplicada'), goal('u1', 'duplicada')],
        ),
      ),
      throwsA(isA<Exception>()),
    );
    final saved = (await store.read('u1'))!;
    expect(saved.accounts.single.accountId, 'original');
    expect(saved.goals.single.goalId, 'meta');
    expect(saved.updatedAt.toUtc(), originalTime);
  });

  test('rechaza datos de otro usuario sin modificar la captura', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final store = LocalBalanceSnapshotStore(db);
    await store.replace(
      snapshot('u1', accounts: [account('u1', 'original', 1)]),
    );
    await expectLater(
      store.replace(snapshot('u1', accounts: [account('u2', 'ajena', 2)])),
      throwsArgumentError,
    );
    expect((await store.read('u1'))!.accounts.single.accountId, 'original');
    expect(await store.read('u2'), isNull);
  });

  test('la captura persiste al cerrar y reabrir un archivo temporal', () async {
    final dir = await Directory.systemTemp.createTemp('mibolsillo_snapshot_');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}${Platform.pathSeparator}test.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    await LocalBalanceSnapshotStore(first)
        .replace(snapshot('u1', accounts: [account('u1', 'banco', 12345)]));
    await first.close();
    final second = AppDatabase(NativeDatabase(file));
    try {
      expect(
        (await LocalBalanceSnapshotStore(second).read('u1'))!
            .accounts
            .single
            .balanceCents,
        12345,
      );
    } finally {
      await second.close();
    }
  });
}
