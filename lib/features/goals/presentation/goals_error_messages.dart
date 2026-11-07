// Archivo: lib/features/goals/presentation/goals_error_messages.dart
//
// Traduce los motivos de [GoalsError] al texto del idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/goals_repository.dart';

extension GoalsErrorMessage on GoalsError {
  /// Mensaje listo para mostrar al usuario.
  String message(AppLocalizations l10n) {
    return switch (this) {
      GoalsError.load => l10n.goalsLoadError,
      GoalsError.save => l10n.goalsSaveError,
      GoalsError.permission => l10n.goalsPermissionError,
      GoalsError.invalidData => l10n.goalsInvalidData,
      GoalsError.saveUnknown => l10n.goalsSaveUnknown,
      GoalsError.sessionExpired => l10n.sessionExpired,
    };
  }
}
