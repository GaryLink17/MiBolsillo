// Archivo: lib/core/supabase/supabase_bootstrap.dart
//
// Inicialización y acceso al cliente de Supabase. La app puede arrancar sin
// credenciales (modo local); en ese caso este archivo devuelve `null`.

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
///
/// Los repositorios reciben este cliente por constructor; así los tests pueden
/// sustituirlo o trabajar sin red.
SupabaseClient? get supabaseClient =>
    AppEnv.hasSupabase ? Supabase.instance.client : null;
