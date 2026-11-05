// Archivo: lib/app/theme/app_spacing.dart
//
// Escala de espaciados y radios usada en toda la interfaz.

/// Espaciados base (múltiplos de 4) para mantener ritmo visual consistente.
///
/// Se usan en lugar de números sueltos para que un cambio global sea sencillo.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 40;
}

/// Radios de borde reutilizables.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 26;
  static const double pill = 999;
}
