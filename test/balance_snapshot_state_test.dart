// Archivo: test/balance_snapshot_state_test.dart
//
// Pruebas del contrato de estados de la captura de cuentas y metas.

import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/features/accounts/data/account.dart';
import 'package:mibolsillo/features/balances/data/balance_snapshot_state.dart';
import 'package:mibolsillo/features/goals/data/savings_goal.dart';

void main() {
  test('una captura completa puede contener listas vacías', () {
    final snapshot = BalanceSnapshot(
      userId: 'usuario-1',
      accounts: [],
      goals: [],
      updatedAt: DateTime.utc(2026, 11, 12),
    );
    final state = BalanceSnapshotAvailable(snapshot);

    expect(state.snapshot.accounts, isEmpty);
    expect(state.snapshot.goals, isEmpty);
    expect(state.snapshot.userId, 'usuario-1');
    expect(state.snapshot.updatedAt, DateTime.utc(2026, 11, 12));
    expect(
      const BalanceSnapshotUnavailable(),
      isNot(isA<BalanceSnapshotAvailable>()),
    );
  });

  test('una captura protege sus listas frente a cambios externos', () {
    final accounts = <AccountSummary>[];
    final goals = <SavingsGoal>[];
    final snapshot = BalanceSnapshot(
      userId: 'usuario-1',
      accounts: accounts,
      goals: goals,
      updatedAt: DateTime.utc(2026, 11, 12),
    );
    const account = AccountSummary(
      id: 'cuenta-1',
      name: 'Banco',
      kind: AccountKind.banco,
      balance: 100,
    );
    accounts.add(account);

    expect(snapshot.accounts, isEmpty);
    expect(() => snapshot.accounts.add(account), throwsUnsupportedError);
    expect(() => snapshot.goals.clear(), throwsUnsupportedError);
  });

  test('el estado desactualizado conserva la última captura', () {
    final snapshot = BalanceSnapshot(
      userId: 'usuario-1',
      accounts: [],
      goals: [],
      updatedAt: DateTime.utc(2026, 11, 12),
    );
    final state = BalanceSnapshotStale(snapshot);

    expect(state.snapshot, same(snapshot));
    expect(const BalanceSnapshotLoading(), isA<BalanceSnapshotState>());
  });
}
