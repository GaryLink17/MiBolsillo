// Archivo: lib/features/movements/presentation/movements_error_messages.dart
//
// Traduce los motivos de [MovementsError] al texto del idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/movements_repository.dart';

extension MovementsErrorMessage on MovementsError {
  /// Mensaje listo para mostrar al usuario.
  String message(AppLocalizations l10n) {
    return switch (this) {
      MovementsError.load => l10n.movementsLoadError,
      MovementsError.save => l10n.movementsSaveError,
      MovementsError.totals => l10n.movementsTotalsError,
      MovementsError.permission => l10n.movementsPermissionError,
      MovementsError.relatedMissing => l10n.movementsRelatedMissing,
      MovementsError.invalidData => l10n.movementsInvalidData,
      MovementsError.saveUnknown => l10n.movementsSaveUnknown,
      MovementsError.sessionExpired => l10n.sessionExpired,
    };
  }
}
