// Archivo: lib/core/preferences/app_preferences.dart
//
// Preferencias locales del dispositivo: tema visual y si el tutorial ya se
// completó. Se guardan con `shared_preferences`, no en Supabase, porque son
// ajustes propios de este teléfono.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Claves centralizadas para no repetir strings en toda la app.
///
/// Si una clave cambia, solo se modifica aquí.
abstract final class PreferenceKeys {
  static const onboardingCompleted = 'onboarding_completed';
  static const themeMode = 'theme_mode';
  static const language = 'language';
}

/// Instancia de `SharedPreferences` cargada en `main()`.
///
/// Se sobreescribe en el `ProviderScope` raíz con la instancia ya lista. Si
/// alguien intenta leerla sin hacerlo, el error avisa de la configuración
/// faltante en lugar de fallar de forma confusa.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider debe sobrescribirse en ProviderScope.',
  );
});

/// Controla el tema (claro, oscuro o el del sistema) y lo persiste.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Al arrancar se restaura la última elección. Si no existe o no se
    // reconoce, se usa el tema del sistema.
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(PreferenceKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  /// Cambia el tema y lo guarda en el dispositivo.
  Future<void> set(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(PreferenceKeys.themeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

/// Idiomas que puede elegir el usuario.
///
/// `system` significa "usar el idioma del teléfono". Los otros dos fuerzan
/// español o inglés sin importar la configuración del dispositivo.
enum AppLanguage { system, spanish, english }

/// Controla el idioma de la app y lo persiste en el dispositivo.
///
/// El idioma por defecto es español para conservar el comportamiento actual.
/// Si no hay valor guardado, o el valor no se reconoce, se usa español.
class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(PreferenceKeys.language);

    return AppLanguage.values.firstWhere(
      (language) => language.name == stored,
      orElse: () => AppLanguage.spanish,
    );
  }

  /// Cambia el idioma y lo guarda para el próximo arranque.
  Future<void> set(AppLanguage language) async {
    if (state == language) return;
    state = language;
    await ref
        .read(sharedPreferencesProvider)
        .setString(PreferenceKeys.language, language.name);
  }
}

final languageProvider = NotifierProvider<LanguageController, AppLanguage>(
  LanguageController.new,
);

/// Convierte la preferencia de idioma en el `Locale` que entiende Flutter.
///
/// `null` le dice a `MaterialApp` que use el idioma del sistema.
Locale? localeFor(AppLanguage language) {
  return switch (language) {
    AppLanguage.system => null,
    AppLanguage.spanish => const Locale('es'),
    AppLanguage.english => const Locale('en'),
  };
}

/// Recuerda si el usuario ya completó el tutorial de bienvenida.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(PreferenceKeys.onboardingCompleted) ??
        false;
  }

  /// Marca el tutorial como completado para no volver a mostrarlo.
  Future<void> complete() async {
    if (state == true) return;
    state = true;
    await ref
        .read(sharedPreferencesProvider)
        .setBool(PreferenceKeys.onboardingCompleted, true);
  }
}

final onboardingCompletedProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);
