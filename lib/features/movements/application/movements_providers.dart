import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/movements_repository.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final movementsRepositoryProvider = Provider<MovementsRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : MovementsRepository(client);
});
