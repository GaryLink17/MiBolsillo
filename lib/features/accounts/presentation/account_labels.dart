// Archivo: lib/features/accounts/presentation/account_labels.dart
//
// Textos visibles de [AccountKind] en el idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/account.dart';

extension AccountKindLabel on AccountKind {
  /// Nombre del tipo de cuenta para mostrar y usar como nombre inicial.
  String label(AppLocalizations l10n) {
    return switch (this) {
      AccountKind.efectivo => l10n.accountCash,
      AccountKind.banco => l10n.accountBank,
      AccountKind.ahorro => l10n.accountSavings,
      AccountKind.tarjeta => l10n.accountCard,
      AccountKind.otro => l10n.accountOther,
    };
  }
}
