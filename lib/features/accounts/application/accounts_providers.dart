import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/account.dart';
import '../data/accounts_repository.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final accountsRepositoryProvider = Provider<AccountsRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : AccountsRepository(client);
});

/// Cuentas del usuario con su saldo actual.
///
/// En modo local devuelve una lista vacía para que la interfaz muestre los
/// estados vacíos en lugar de fallar.
final accountsProvider = FutureProvider.autoDispose<List<AccountSummary>>((
  ref,
) async {
  final repository = ref.watch(accountsRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});
