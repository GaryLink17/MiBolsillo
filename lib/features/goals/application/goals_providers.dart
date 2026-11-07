// Archivo: lib/features/goals/application/goals_providers.dart
//
// Providers de Riverpod para las metas de ahorro. Conectan el repositorio con
// la interfaz y permiten invalidar la lista después de crear una meta.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/goals_repository.dart';
import '../data/savings_goal.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final goalsRepositoryProvider = Provider<GoalsRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : GoalsRepository(client);
});

/// Metas del usuario con su progreso.
///
/// En modo local devuelve una lista vacía para que la interfaz muestre el
/// estado vacío en lugar de fallar.
///
/// Es `autoDispose` para no conservar datos de una sesión anterior cuando se
/// cierra sesión y entra otra persona en el mismo teléfono.
final goalsProvider = FutureProvider.autoDispose<List<SavingsGoal>>((
  ref,
) async {
  final repository = ref.watch(goalsRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});
