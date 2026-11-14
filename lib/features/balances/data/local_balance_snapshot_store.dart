// Archivo: lib/features/balances/data/local_balance_snapshot_store.dart
//
// Almacenamiento local de capturas completas. No descarga datos ni gestiona
// autenticación; quien lo use debe proporcionar el usuario autenticado.

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/foundation.dart' show immutable;

import '../../../core/database/app_database.dart';

/// Datos exactos en centavos de una captura local, antes de adaptarlos a la UI.
@immutable
class LocalBalanceSnapshot {
  LocalBalanceSnapshot({
    required this.userId,
    required this.updatedAt,
    required List<CachedAccount> accounts,
    required List<CachedGoal> goals,
  }) : accounts = List.unmodifiable(accounts),
       goals = List.unmodifiable(goals);

  final String userId;
  final DateTime updatedAt;
  final List<CachedAccount> accounts;
  final List<CachedGoal> goals;
}

/// Lee y reemplaza la captura completa de un usuario en transacciones SQLite.
class LocalBalanceSnapshotStore {
  LocalBalanceSnapshotStore(this._db);

  final AppDatabase _db;

  /// Devuelve `null` si nunca se guardó una captura completa para el usuario.
  Future<LocalBalanceSnapshot?> read(String userId) async {
    _checkUserId(userId);
    return _db.transaction(() async {
      final metadata = await (_db.select(
        _db.balanceSnapshotMetadata,
      )..where((row) => row.userId.equals(userId))).getSingleOrNull();
      if (metadata == null) return null;

      final accounts =
          await (_db.select(_db.cachedAccounts)
                ..where((row) => row.userId.equals(userId))
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      final goals =
          await (_db.select(_db.cachedGoals)
                ..where((row) => row.userId.equals(userId))
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      return LocalBalanceSnapshot(
        userId: userId,
        updatedAt: metadata.updatedAt,
        accounts: accounts,
        goals: goals,
      );
    });
  }

  /// Sustituye cuentas, metas y metadatos en una única transacción.
  /// Un error conserva íntegramente la captura anterior.
  Future<void> replace(LocalBalanceSnapshot snapshot) async {
    final userId = snapshot.userId;
    _checkUserId(userId);
    if (snapshot.accounts.any((row) => row.userId != userId) ||
        snapshot.goals.any((row) => row.userId != userId)) {
      throw ArgumentError('La captura contiene datos de otro usuario.');
    }

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedAccounts,
      )..where((row) => row.userId.equals(userId))).go();
      await (_db.delete(
        _db.cachedGoals,
      )..where((row) => row.userId.equals(userId))).go();
      await _db.batch((batch) {
        batch.insertAll(_db.cachedAccounts, snapshot.accounts);
        batch.insertAll(_db.cachedGoals, snapshot.goals);
      });
      await _db
          .into(_db.balanceSnapshotMetadata)
          .insertOnConflictUpdate(
            BalanceSnapshotMetadataCompanion.insert(
              userId: userId,
              updatedAt: snapshot.updatedAt,
            ),
          );
    });
  }

  void _checkUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('El usuario es obligatorio.');
    }
  }
}
