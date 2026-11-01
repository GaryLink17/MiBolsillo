import 'package:supabase_flutter/supabase_flutter.dart';

/// Error de autenticación con un mensaje ya listo para mostrar al usuario.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Session? get currentSession => _client.auth.currentSession;

  Future<Session?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      return response.session;
    } on AuthException catch (error) {
      throw AuthFailure(_translate(error.message));
    } catch (_) {
      throw const AuthFailure(
        'No pudimos conectar. Revisa tu internet e intenta de nuevo.',
      );
    }
  }

  Future<Session?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
      return response.session;
    } on AuthException catch (error) {
      throw AuthFailure(_translate(error.message));
    } catch (_) {
      throw const AuthFailure(
        'No pudimos conectar. Revisa tu internet e intenta de nuevo.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      throw const AuthFailure('No pudimos cerrar la sesión. Intenta de nuevo.');
    }
  }

  static String _translate(String raw) {
    final message = raw.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (message.contains('email not confirmed')) {
      return 'Confirma tu correo antes de entrar.';
    }
    if (message.contains('already registered') ||
        message.contains('already been registered')) {
      return 'Ese correo ya tiene una cuenta.';
    }
    if (message.contains('password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (message.contains('invalid format') ||
        message.contains('unable to validate email')) {
      return 'Escribe un correo válido.';
    }
    if (message.contains('signups not allowed') ||
        message.contains('signup is disabled')) {
      return 'El registro está desactivado por ahora.';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
    }
    return 'No pudimos completar la operación. Intenta de nuevo.';
  }
}
