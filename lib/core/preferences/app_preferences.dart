import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Claves centralizadas para no repetir strings en toda la app.
abstract final class PreferenceKeys {
  static const onboardingCompleted = 'onboarding_completed';
  static const themeMode = 'theme_mode';
}

/// Se sobreescribe en `main()` con la instancia ya cargada, para que el primer
/// frame ya conozca las preferencias (sin pantalla de carga intermedia).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider debe sobrescribirse en ProviderScope.',
  );
});

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(PreferenceKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

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

class OnboardingController extends Notifier<bool> {
  @override
  bool build() {
    return ref
            .watch(sharedPreferencesProvider)
            .getBool(PreferenceKeys.onboardingCompleted) ??
        false;
  }

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
