// Archivo: lib/features/accounts/presentation/accounts_error_messages.dart
//
// Traduce los motivos de [AccountsError] al texto del idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/accounts_repository.dart';

extension AccountsErrorMessage on AccountsError {
  /// Mensaje listo para mostrar al usuario.
  String message(AppLocalizations l10n) {
    return switch (this) {
      AccountsError.load => l10n.accountsLoadError,
      AccountsError.save => l10n.accountsSaveError,
      AccountsError.permission => l10n.accountsPermissionError,
      AccountsError.sessionExpired => l10n.sessionExpired,
    };
  }
}
