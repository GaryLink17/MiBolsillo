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

/// Sesión actual.
///
/// Es síncrona a propósito: al arrancar, Supabase ya restauró la sesión guardada
/// en el dispositivo, así el router decide en el primer frame si mostrar el
/// acceso o el inicio (sin pantalla de carga intermedia).
class SessionController extends Notifier<Session?> {
  @override
  Session? build() {
    final client = ref.watch(supabaseClientProvider);
    if (client == null) return null;

    var disposed = false;
    final subscription = client.auth.onAuthStateChange.listen((state) {
      if (!disposed) this.state = state.session;
    });
    ref.onDispose(() {
      disposed = true;
      subscription.cancel();
    });

    return client.auth.currentSession;
  }
}

final sessionProvider = NotifierProvider<SessionController, Session?>(
  SessionController.new,
);
