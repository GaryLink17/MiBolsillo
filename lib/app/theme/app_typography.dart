// Archivo: lib/app/theme/app_typography.dart
//
// Escala tipográfica de la app. Se define una sola vez para que todos los
// textos mantengan el mismo tamaño, peso y altura de línea.

import 'package:flutter/material.dart';

/// Construye el `TextTheme` base de Mi Bolsillo.
///
/// `muted` se usa como color de los textos secundarios (`bodySmall`). El resto
/// de colores se aplican después en `buildAppTheme` con `.apply(...)`.
abstract final class AppTypography {
  static TextTheme textTheme({required Color muted}) {
    // Las cifras tabulares hacen que los montos no "salten" al cambiar de
    // dígito, algo importante en listas y balances.
    const tabular = [FontFeature.tabularFigures()];
    return TextTheme(
      displayLarge: const TextStyle(
        fontSize: 46,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.8,
        fontFeatures: tabular,
      ),
      displayMedium: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.2,
        fontFeatures: tabular,
      ),
      displaySmall: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.8,
        fontFeatures: tabular,
      ),
      headlineLarge: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.8,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4,
      ),
      headlineSmall: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: muted,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelSmall: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
      ),
    ).apply(fontFamily: 'Inter');
  }
}
