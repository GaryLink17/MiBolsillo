// Archivo: lib/features/auth/data/auth_repository.dart
//
// Envuelve las operaciones de autenticación de Supabase. Los errores se
// devuelven como un [AuthError] tipado; la capa de presentación decide cómo
// traducirlos al idioma activo.

import 'package:supabase_flutter/supabase_flutter.dart';

/// Motivos por los que una operación de autenticación puede fallar.
///
/// No contienen texto visible: eso permite traducirlos sin acoplar la capa de
/// datos a un idioma concreto.
enum AuthError {
  invalidCredentials,
  emailNotConfirmed,
  alreadyRegistered,
  weakPassword,
  invalidEmail,
  signupDisabled,
  rateLimited,
  network,
  signOutFailed,
  unknown,
}

/// Error de autenticación con el motivo tipado.
class AuthFailure implements Exception {
  const AuthFailure(this.error);

  final AuthError error;

  @override
  String toString() => 'AuthFailure(${error.name})';
}

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Session? get currentSession => _client.auth.currentSession;

  /// Inicia sesión con correo y contraseña.
  ///
  /// Devuelve la sesión creada. Si Supabase rechaza las credenciales o falla
  /// la red, lanza [AuthFailure] con el motivo correspondiente.
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
      throw const AuthFailure(AuthError.network);
    }
  }

  /// Crea una cuenta nueva con nombre, correo y contraseña.
  ///
  /// El nombre se guarda en `user_metadata` para mostrarlo luego en Ajustes.
  /// Si el proyecto exige confirmación de correo, `response.session` será
  /// `null`; la pantalla de registro lo usa para avisar al usuario.
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
      throw const AuthFailure(AuthError.network);
    }
  }

  /// Cierra la sesión del dispositivo.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {
      throw const AuthFailure(AuthError.signOutFailed);
    }
  }

  /// Traduce los mensajes técnicos de Supabase a un [AuthError].
  ///
  /// Se compara en minúsculas porque los textos originales pueden variar en
  /// mayúsculas según el proveedor.
  static AuthError _translate(String raw) {
    final message = raw.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return AuthError.invalidCredentials;
    }
    if (message.contains('email not confirmed')) {
      return AuthError.emailNotConfirmed;
    }
    if (message.contains('already registered') ||
        message.contains('already been registered')) {
      return AuthError.alreadyRegistered;
    }
    if (message.contains('password should be at least')) {
      return AuthError.weakPassword;
    }
    if (message.contains('invalid format') ||
        message.contains('unable to validate email')) {
      return AuthError.invalidEmail;
    }
    if (message.contains('signups not allowed') ||
        message.contains('signup is disabled')) {
      return AuthError.signupDisabled;
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return AuthError.rateLimited;
    }
    return AuthError.unknown;
  }
}
