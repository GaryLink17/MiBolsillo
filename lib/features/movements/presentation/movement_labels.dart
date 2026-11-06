// Archivo: lib/features/movements/presentation/movement_labels.dart
//
// Textos visibles de [MovementType] en el idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/movement.dart';

extension MovementTypeLabel on MovementType {
  /// Nombre singular del tipo de movimiento (Gasto / Ingreso).
  String label(AppLocalizations l10n) {
    return switch (this) {
      MovementType.gasto => l10n.movementExpense,
      MovementType.ingreso => l10n.movementIncome,
    };
  }

  /// Texto del botón que guarda el movimiento.
  String saveLabel(AppLocalizations l10n) {
    return switch (this) {
      MovementType.gasto => l10n.saveExpense,
      MovementType.ingreso => l10n.saveIncome,
    };
  }

  /// Mensaje de confirmación tras guardar.
  String savedMessage(AppLocalizations l10n) {
    return switch (this) {
      MovementType.gasto => l10n.expenseSaved,
      MovementType.ingreso => l10n.incomeSaved,
    };
  }
}
