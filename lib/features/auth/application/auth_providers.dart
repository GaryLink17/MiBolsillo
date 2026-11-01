import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_bootstrap.dart';
import '../data/auth_repository.dart';

/// `null` cuando la app corre en modo local (sin `env.json`).
final supabaseClientProvider = Provider<SupabaseClient?>(
  (ref) => supabaseClient,
);

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : AuthRepository(client);
});

/// Sesión actual. Se actualiza sola cuando entra, sale o cambia el token.
final authStateProvider = StreamProvider<Session?>((ref) async* {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    yield null;
    return;
  }
  yield client.auth.currentSession;
  await for (final state in client.auth.onAuthStateChange) {
    yield state.session;
  }
});
