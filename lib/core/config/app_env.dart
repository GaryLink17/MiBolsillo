/// Configuración que llega al compilar, no al repositorio.
///
/// Los valores se leen desde `env.json` con
/// `flutter run --dart-define-from-file=env.json`.
/// Si faltan, la app arranca en modo local (sin nube) en lugar de fallar.
abstract final class AppEnv {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
