import 'package:supabase_flutter/supabase_flutter.dart';

import 'account.dart';

/// Error de cuentas con un mensaje ya listo para mostrar al usuario.
class AccountsFailure implements Exception {
  const AccountsFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class AccountsRepository {
  AccountsRepository(this._client);

  final SupabaseClient _client;

  /// Cuentas activas con su saldo real (saldo inicial + movimientos).
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
      throw const AccountsFailure(
        'No pudimos cargar tus cuentas. Revisa tu conexión.',
      );
    } catch (_) {
      throw const AccountsFailure(
        'No pudimos cargar tus cuentas. Revisa tu conexión.',
      );
    }
  }

  /// Crea las cuentas del saldo inicial en una sola operación.
  Future<void> createInitial(List<InitialAccount> accounts) async {
    if (accounts.isEmpty) return;

    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AccountsFailure('Tu sesión expiró. Vuelve a entrar.');
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
      if (error.code == '42501') {
        throw const AccountsFailure(
          'Tu cuenta no tiene permisos para guardar. Vuelve a entrar.',
        );
      }
      throw const AccountsFailure(
        'No pudimos guardar tus cuentas. Revisa tu conexión.',
      );
    } catch (_) {
      throw const AccountsFailure(
        'No pudimos guardar tus cuentas. Revisa tu conexión.',
      );
    }
  }
}
