// Archivo: lib/app/app.dart
//
// Widget raíz de Mi Bolsillo. Configura:
// - el router (GoRouter) que decide qué pantalla mostrar;
// - el tema claro y oscuro;
// - el idioma de la app (`es_DO`);
// - el estilo de las barras del sistema (estado y navegación).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/preferences/app_preferences.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Raíz de la aplicación.
///
/// Es un `ConsumerWidget` porque reacciona a dos providers:
/// - `routerProvider`: instancia única del router.
/// - `themeModeProvider`: preferencia claro/oscuro/sistema.
class MiBolsilloApp extends ConsumerWidget {
  const MiBolsilloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Mi Bolsillo',
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // El tema se construye a partir de una única fuente de verdad
      // (`buildAppTheme`), una vez para claro y otra para oscuro.
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: themeMode,

      // Toda la app está en español de República Dominicana. Se dejan `es` y
      // `en` como respaldo para que Flutter siempre encuentre localizaciones.
      locale: const Locale('es', 'DO'),
      supportedLocales: const [Locale('es', 'DO'), Locale('es'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // `builder` envuelve todas las pantallas para pintar las barras del
      // sistema transparentes y elegir iconos claros u oscuros según el tema.
      builder: (context, child) {
        final isLight = Theme.of(context).brightness == Brightness.light;
        final overlayStyle =
            (isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light)
                .copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: isLight
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarContrastEnforced: false,
                );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
