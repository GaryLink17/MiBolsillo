// Archivo: lib/features/categories/presentation/category_labels.dart
//
// Traduce los nombres de las categorías por defecto que hoy se siembran en
// español desde Supabase. Las categorías creadas por el usuario conservan su
// nombre tal cual; este mapeo solo actúa sobre los nombres conocidos.

import '../../../l10n/generated/app_localizations.dart';
import '../data/category.dart';

extension CategoryDisplayName on Category {
  /// Nombre visible de la categoría en el idioma activo.
  String displayName(AppLocalizations l10n) {
    return switch (name) {
      'Comida' => l10n.categoryFood,
      'Transporte' => l10n.categoryTransport,
      'Hogar' => l10n.categoryHome,
      'Ocio' => l10n.categoryLeisure,
      'Salud' => l10n.categoryHealth,
      'Otros' => l10n.categoryOther,
      'Salario' => l10n.categorySalary,
      _ => name,
    };
  }
}
