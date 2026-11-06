// Archivo: lib/features/categories/presentation/categories_error_messages.dart
//
// Traduce los motivos de [CategoriesError] al texto del idioma activo.

import '../../../l10n/generated/app_localizations.dart';
import '../data/categories_repository.dart';

extension CategoriesErrorMessage on CategoriesError {
  /// Mensaje listo para mostrar al usuario.
  String message(AppLocalizations l10n) {
    return switch (this) {
      CategoriesError.load => l10n.categoriesLoadError,
    };
  }
}
