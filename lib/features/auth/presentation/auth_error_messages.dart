// Archivo: lib/features/auth/presentation/auth_error_messages.dart
//
// Traduce los motivos de [AuthError] al texto del idioma activo. Vive en la
// capa de presentación para que el repositorio no dependa de traducciones.

import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_repository.dart';

extension AuthErrorMessage on AuthError {
  /// Mensaje listo para mostrar al usuario.
  String message(AppLocalizations l10n) {
    return switch (this) {
      AuthError.invalidCredentials => l10n.authInvalidCredentials,
      AuthError.emailNotConfirmed => l10n.authEmailNotConfirmed,
      AuthError.alreadyRegistered => l10n.authAlreadyRegistered,
      AuthError.weakPassword => l10n.authWeakPassword,
      AuthError.invalidEmail => l10n.authInvalidEmail,
      AuthError.signupDisabled => l10n.authSignupDisabled,
      AuthError.rateLimited => l10n.authRateLimited,
      AuthError.network => l10n.authNetwork,
      AuthError.signOutFailed => l10n.authSignOutFailed,
      AuthError.unknown => l10n.authUnknown,
    };
  }
}
