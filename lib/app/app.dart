// Archivo: lib/app/app.dart
//
// Widget raíz de Mi Bolsillo. Configura:
// - el router (GoRouter) que decide qué pantalla mostrar;
// - el tema claro y oscuro;
// - el idioma de la app (español, inglés o el del sistema);
// - el estilo de las barras del sistema (estado y navegación).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/preferences/app_preferences.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Raíz de la aplicación.
///
/// Es un `ConsumerWidget` porque reacciona a tres providers:
/// - `routerProvider`: instancia única del router.
/// - `themeModeProvider`: preferencia claro/oscuro/sistema.
/// - `languageProvider`: idioma elegido y su persistencia.
class MiBolsilloApp extends ConsumerWidget {
  const MiBolsilloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final locale = localeFor(language);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // El tema se construye a partir de una única fuente de verdad
      // (`buildAppTheme`), una vez para claro y otra para oscuro.
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: themeMode,

      // El idioma se decide con `languageProvider`. Si vale `system`, el
      // `locale` es `null` y Flutter usa el idioma del dispositivo.
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

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
