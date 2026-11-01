import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_env.dart';

/// Inicializa Supabase solo si existen las credenciales.
///
/// Mientras no estén configuradas, la app funciona con datos locales para que
/// se pueda seguir probando el diseño sin depender de la nube.
Future<void> initSupabaseIfConfigured() async {
  if (!AppEnv.hasSupabase) return;
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    publishableKey: AppEnv.supabaseAnonKey,
  );
}

/// Cliente listo para usar, o `null` si la app está en modo local.
SupabaseClient? get supabaseClient =>
    AppEnv.hasSupabase ? Supabase.instance.client : null;
