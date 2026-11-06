// Archivo: test/localization_test.dart
//
// Comprueba que las pantallas usan las traducciones generadas y que el inglés
// se carga con los delegados de `AppLocalizations`.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/auth/presentation/login_screen.dart';
import 'package:mibolsillo/features/movements/application/movements_providers.dart';
import 'package:mibolsillo/features/movements/presentation/movements_screen.dart';
import 'package:mibolsillo/l10n/generated/app_localizations.dart';

/// Envuelve una pantalla con el idioma indicado y las localizaciones de la app.
Widget _buildApp(Widget home, {required Locale locale}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(null),
      supabaseClientProvider.overrideWithValue(null),
      movementsProvider.overrideWith((ref) async => const []),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  testWidgets('el acceso se muestra en inglés', (tester) async {
    await tester.pumpWidget(
      _buildApp(const LoginScreen(), locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('los estados vacíos se muestran en inglés', (tester) async {
    await tester.pumpWidget(
      _buildApp(const MovementsScreen(), locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Movements'), findsOneWidget);
    expect(find.text('No movements yet'), findsOneWidget);
    expect(find.text('Record the first one'), findsOneWidget);
  });
}
