// Archivo: lib/main.dart
//
// Punto de entrada de Mi Bolsillo.
//
// Antes del primer frame se prepara el entorno:
// 1. Se inicializan los plugins de Flutter.
// 2. Se usa la pantalla completa (edge to edge) y orientación vertical.
// 3. Se inicializa Supabase solo si existen credenciales.
// 4. Se cargan las preferencias locales.
// 5. Se arranca la app dentro de un `ProviderScope` de Riverpod.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/preferences/app_preferences.dart';
import 'core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  // Obligatorio antes de usar plugins o canales nativos.
  WidgetsFlutterBinding.ensureInitialized();

  // El contenido se dibuja detrás de las barras del sistema y la app queda
  // bloqueada en vertical.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Sin `env.json`, esta función no hace nada y la app sigue en modo local.
  await initSupabaseIfConfigured();

  // Se cargan una sola vez y se inyectan al árbol de providers. Así el primer
  // frame ya conoce el tema guardado y si el tutorial fue completado, sin
  // mostrar una pantalla de carga intermedia.
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const MiBolsilloApp(),
    ),
  );
}
