// Archivo: lib/core/l10n/l10n.dart
//
// Acceso corto a las traducciones generadas: `context.l10n`.
//
// Se usa una extensión para no repetir `AppLocalizations.of(context)` en cada
// pantalla y para que el código de presentación quede más legible.

import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  /// Traducciones del idioma activo.
  ///
  /// `AppLocalizations.of` no devuelve `null` porque `l10n.yaml` configura
  /// `nullable-getter: false`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
