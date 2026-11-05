// Archivo: lib/core/config/app_env.dart
//
// Acceso a la configuración que se inyecta al compilar. No contiene secretos:
// los valores vienen de `env.json` mediante
// `--dart-define-from-file=env.json`.

/// Configuración de entorno de la app.
///
/// `String.fromEnvironment` se resuelve en tiempo de compilación, por lo que
/// estas constantes no se pueden cambiar mientras la app está en ejecución.
abstract final class AppEnv {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Indica si las dos credenciales están presentes.
  ///
  /// Si es `false`, la app arranca en modo local y no intenta conectarse.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
