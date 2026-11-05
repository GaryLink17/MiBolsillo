import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/categories_repository.dart';
import '../data/category.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final categoriesRepositoryProvider = Provider<CategoriesRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : CategoriesRepository(client);
});

/// `autoDispose` a propósito: al cerrar sesión y entrar con otra cuenta en el
/// mismo teléfono no deben quedar cacheadas las categorías del usuario anterior.
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((
  ref,
) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  if (repository == null) return const [];
  return repository.list();
});
