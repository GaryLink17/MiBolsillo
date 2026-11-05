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
final movementsProvider = FutureProvider.autoDispose<List<MovementEntry>>((
  ref,
) async {
  final repository = ref.watch(movementsRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});

/// Ingresos y gastos del mes actual.
final monthlyTotalsProvider = FutureProvider.autoDispose<MovementTotals>((
  ref,
) async {
  final repository = ref.watch(movementsRepositoryProvider);
  if (repository == null) return MovementTotals.zero;
  return repository.monthTotals(DateTime.now());
});
