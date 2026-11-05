// Archivo: lib/features/accounts/application/accounts_providers.dart
//
// Providers de Riverpod para las cuentas. Conectan el repositorio con la
// interfaz y permiten invalidar la lista para refrescarla.

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
///
/// Es `autoDispose` para no conservar datos de una sesión anterior cuando se
/// cierra sesión y entra otra persona en el mismo teléfono.
final accountsProvider = FutureProvider.autoDispose<List<AccountSummary>>((
  ref,
) async {
  final repository = ref.watch(accountsRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});
