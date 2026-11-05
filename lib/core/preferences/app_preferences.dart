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
