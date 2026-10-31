import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Construye el tema claro u oscuro a partir de una única fuente de verdad.
ThemeData buildAppTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final palette = isLight ? AppPalette.light : AppPalette.dark;

  final scheme = isLight
      ? const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF147A6D),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFD7F1EA),
          onPrimaryContainer: Color(0xFF0B4A42),
          secondary: Color(0xFF0E7A5F),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFDDF3EB),
          onSecondaryContainer: Color(0xFF063A2E),
          error: Color(0xFFB42318),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFDECEA),
          onErrorContainer: Color(0xFF7A1A14),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF0F1513),
          onSurfaceVariant: Color(0xFF5F6A67),
          outline: Color(0xFFDCE3E0),
          outlineVariant: Color(0xFFE5EAE8),
          inverseSurface: Color(0xFF0F1513),
          onInverseSurface: Color(0xFFF4F6F5),
          surfaceTint: Color(0xFF147A6D),
        )
      : const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF4EE0B0),
          onPrimary: Color(0xFF05241C),
          primaryContainer: Color(0xFF123B32),
          onPrimaryContainer: Color(0xFFBDF6E2),
          secondary: Color(0xFF4EE0B0),
          onSecondary: Color(0xFF05241C),
          secondaryContainer: Color(0xFF17352A),
          onSecondaryContainer: Color(0xFFC9F7E6),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          errorContainer: Color(0xFF93000A),
          onErrorContainer: Color(0xFFFFDAD6),
          surface: Color(0xFF171A19),
          onSurface: Color(0xFFF2F5F3),
          onSurfaceVariant: Color(0xFFA6B0AD),
          outline: Color(0xFF3A413F),
          outlineVariant: Color(0xFF272C2A),
          inverseSurface: Color(0xFFF2F5F3),
          onInverseSurface: Color(0xFF171A19),
          surfaceTint: Color(0xFF4EE0B0),
        );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: 'Inter',
  );

  final textTheme = AppTypography.textTheme(muted: palette.muted)
      .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

  final roundedField = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: palette.border),
  );

  return base.copyWith(
    scaffoldBackgroundColor: palette.background,
    canvasColor: palette.background,
    textTheme: textTheme,
    extensions: [palette],
    dividerColor: palette.border,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: palette.border),
        textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      hintStyle: textTheme.bodyLarge?.copyWith(color: palette.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: roundedField,
      enabledBorder: roundedField,
      disabledBorder: roundedField,
      focusedBorder: roundedField.copyWith(
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      errorBorder: roundedField.copyWith(
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: roundedField.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: palette.border,
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isLight ? scheme.inverseSurface : palette.surfaceAlt,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: isLight ? scheme.onInverseSurface : scheme.onSurface,
      ),
      actionTextColor: scheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isLight ? BorderSide.none : BorderSide(color: palette.border),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: palette.border,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: scheme.primary,
      selectionColor: scheme.primary.withValues(alpha: 0.25),
      selectionHandleColor: scheme.primary,
    ),
  );
}
