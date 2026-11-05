// Archivo: lib/app/theme/app_colors.dart
//
// Paleta semántica de la app. Además del `ColorScheme` de Material, aquí viven
// colores que Material no contempla: fondos de categorías, tono de ingreso,
// bordes y textos atenuados.
//
// `AppPalette` es un `ThemeExtension`, por lo que se puede leer en cualquier
// widget con `context.palette` y se interpola al cambiar de tema.

import 'package:flutter/material.dart';

/// Tono visual de una categoría. El color exacto depende del tema
/// (claro/oscuro) y vive en [AppPalette].
enum CategoryTone { food, transport, home, leisure, health, income, other }

/// Par de colores (fondo y primer plano) para un tono de categoría.
@immutable
class ToneColors {
  const ToneColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

/// Colores semánticos que no existen en [ColorScheme] y que usamos en toda
/// la app (tintes de categorías, ingresos, bordes, etc.).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.muted,
    required this.income,
    required this.incomeBackground,
    required this.danger,
    required this.dangerBackground,
    required this.tones,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color muted;
  final Color income;
  final Color incomeBackground;
  final Color danger;
  final Color dangerBackground;
  final Map<CategoryTone, ToneColors> tones;

  /// Devuelve los colores del tono indicado. Todos los tonos están definidos
  /// en [light] y [dark], por eso se puede usar `!`.
  ToneColors tone(CategoryTone tone) => tones[tone]!;

  /// Paleta del tema claro.
  static const light = AppPalette(
    background: Color(0xFFF4F6F5),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEDF1EF),
    border: Color(0xFFE5EAE8),
    muted: Color(0xFF6B7573),
    income: Color(0xFF0E7A5F),
    incomeBackground: Color(0xFFDDF3EB),
    danger: Color(0xFFD92D20),
    dangerBackground: Color(0xFFFDECEA),
    tones: {
      CategoryTone.food: ToneColors(
        background: Color(0xFFFBE9DC),
        foreground: Color(0xFFD9772E),
      ),
      CategoryTone.transport: ToneColors(
        background: Color(0xFFE4EDFB),
        foreground: Color(0xFF3B82F6),
      ),
      CategoryTone.home: ToneColors(
        background: Color(0xFFECE7FB),
        foreground: Color(0xFF7C5CE0),
      ),
      CategoryTone.leisure: ToneColors(
        background: Color(0xFFFBE3EC),
        foreground: Color(0xFFE0447A),
      ),
      CategoryTone.health: ToneColors(
        background: Color(0xFFE0F3EA),
        foreground: Color(0xFF10A36F),
      ),
      CategoryTone.income: ToneColors(
        background: Color(0xFFDDF3EB),
        foreground: Color(0xFF0E7A5F),
      ),
      CategoryTone.other: ToneColors(
        background: Color(0xFFECEFEE),
        foreground: Color(0xFF7A8582),
      ),
    },
  );

  /// Paleta del tema oscuro. Mantiene los mismos nombres semánticos para que
  /// las pantallas no tengan que preguntar por el tema.
  static const dark = AppPalette(
    background: Color(0xFF0B0E0D),
    surface: Color(0xFF171A19),
    surfaceAlt: Color(0xFF202524),
    border: Color(0xFF272C2A),
    muted: Color(0xFF98A29F),
    income: Color(0xFF4EE0B0),
    incomeBackground: Color(0xFF13332A),
    danger: Color(0xFFFF8A80),
    dangerBackground: Color(0xFF3A1F1D),
    tones: {
      CategoryTone.food: ToneColors(
        background: Color(0xFF3A2A1D),
        foreground: Color(0xFFFF9D5C),
      ),
      CategoryTone.transport: ToneColors(
        background: Color(0xFF1C2A3D),
        foreground: Color(0xFF6EA8FF),
      ),
      CategoryTone.home: ToneColors(
        background: Color(0xFF2A2340),
        foreground: Color(0xFFA78BFA),
      ),
      CategoryTone.leisure: ToneColors(
        background: Color(0xFF3A1F2A),
        foreground: Color(0xFFFF7BA5),
      ),
      CategoryTone.health: ToneColors(
        background: Color(0xFF17352A),
        foreground: Color(0xFF4EE0B0),
      ),
      CategoryTone.income: ToneColors(
        background: Color(0xFF13332A),
        foreground: Color(0xFF4EE0B0),
      ),
      CategoryTone.other: ToneColors(
        background: Color(0xFF262B29),
        foreground: Color(0xFFA6B0AD),
      ),
    },
  );

  /// Crea una copia cambiando solo los colores indicados.
  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? muted,
    Color? income,
    Color? incomeBackground,
    Color? danger,
    Color? dangerBackground,
    Map<CategoryTone, ToneColors>? tones,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      muted: muted ?? this.muted,
      income: income ?? this.income,
      incomeBackground: incomeBackground ?? this.incomeBackground,
      danger: danger ?? this.danger,
      dangerBackground: dangerBackground ?? this.dangerBackground,
      tones: tones ?? this.tones,
    );
  }

  /// Interpola entre la paleta actual y otra. Flutter lo usa durante la
  /// transición entre tema claro y oscuro.
  @override
  AppPalette lerp(covariant ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      income: Color.lerp(income, other.income, t)!,
      incomeBackground: Color.lerp(
        incomeBackground,
        other.incomeBackground,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBackground: Color.lerp(
        dangerBackground,
        other.dangerBackground,
        t,
      )!,
      tones: {
        for (final tone in CategoryTone.values)
          tone: ToneColors(
            background: Color.lerp(
              tones[tone]!.background,
              other.tones[tone]!.background,
              t,
            )!,
            foreground: Color.lerp(
              tones[tone]!.foreground,
              other.tones[tone]!.foreground,
              t,
            )!,
          ),
      },
    );
  }
}

/// Atajo para leer la paleta desde cualquier `BuildContext`.
extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
