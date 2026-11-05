// Archivo: lib/features/movements/application/movements_providers.dart
//
// Providers de movimientos y totales. La interfaz observa estos providers y
// se reconstruye sola cuando cambian.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final movementsRepositoryProvider = Provider<MovementsRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : MovementsRepository(client);
});

/// Lista de movimientos del usuario.
///
/// En modo local devuelve una lista vacía para que la pantalla muestre el
/// estado vacío en lugar de fallar.
final movementsProvider = FutureProvider.autoDispose<List<MovementEntry>>((
  ref,
) async {
  final repository = ref.watch(movementsRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});

/// Ingresos y gastos del mes actual.
///
/// Se mantiene separado de [movementsProvider] para que los totales no
/// dependan de los filtros o de la paginación de la lista.
final monthlyTotalsProvider = FutureProvider.autoDispose<MovementTotals>((
  ref,
) async {
  final repository = ref.watch(movementsRepositoryProvider);
  if (repository == null) return MovementTotals.zero;
  return repository.monthTotals(DateTime.now());
});
