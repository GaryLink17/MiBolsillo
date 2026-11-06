// Archivo: lib/features/accounts/data/accounts_repository.dart
//
// Acceso a las cuentas del usuario en Supabase. Los fallos se devuelven como
// un [AccountsError] tipado y la interfaz los traduce al idioma activo.

import 'package:supabase_flutter/supabase_flutter.dart';

import 'account.dart';

/// Motivos por los que una operación con cuentas puede fallar.
enum AccountsError { load, save, permission, sessionExpired }

/// Error de cuentas con el motivo tipado.
class AccountsFailure implements Exception {
  const AccountsFailure(this.error);

  final AccountsError error;

  @override
  String toString() => 'AccountsFailure(${error.name})';
}

class AccountsRepository {
  AccountsRepository(this._client);

  final SupabaseClient _client;

  /// Cuentas activas con su saldo real (saldo inicial + movimientos).
  ///
  /// Se hacen dos consultas: una a `accounts` para los datos y otra a la vista
  /// `account_balances` para los saldos. Luego se combinan en memoria usando el
  /// id. Se filtra `is_archived = false` para no mostrar cuentas ocultas.
  Future<List<AccountSummary>> list() async {
    try {
      final accounts = await _client
          .from('accounts')
          .select('id, name, kind, created_at')
          .eq('is_archived', false)
          .order('created_at');

      final balances = await _client
          .from('account_balances')
          .select('id, balance')
          .eq('is_archived', false);

      // Índice id → saldo para no recorrer la lista de saldos por cada cuenta.
      final balanceById = <String, double>{
        for (final row in balances)
          row['id'] as String: (row['balance'] as num?)?.toDouble() ?? 0,
      };

      return [
        for (final row in accounts)
          AccountSummary(
            id: row['id'] as String,
            name: row['name'] as String,
            kind: AccountKind.fromDb(row['kind'] as String?),
            balance: balanceById[row['id'] as String] ?? 0,
          ),
      ];
    } on PostgrestException {
      throw const AccountsFailure(AccountsError.load);
    } catch (_) {
      throw const AccountsFailure(AccountsError.load);
    }
  }

  /// Crea las cuentas del saldo inicial en una sola operación.
  ///
  /// Se envía una lista para que Supabase haga un único insert. El `user_id`
  /// sale de la sesión actual y queda protegido por las políticas RLS.
  Future<void> createInitial(List<InitialAccount> accounts) async {
    if (accounts.isEmpty) return;

    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AccountsFailure(AccountsError.sessionExpired);
    }

    try {
      await _client.from('accounts').insert([
        for (final account in accounts)
          {
            'user_id': userId,
            'name': account.name,
            'kind': account.kind.name,
            'initial_balance': account.amount,
          },
      ]);
    } on PostgrestException catch (error) {
      // 42501 = la política RLS rechazó la operación.
      if (error.code == '42501') {
        throw const AccountsFailure(AccountsError.permission);
      }
      throw const AccountsFailure(AccountsError.save);
    } catch (_) {
      throw const AccountsFailure(AccountsError.save);
    }
  }
}
