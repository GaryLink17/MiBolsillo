import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/app.dart';
import 'package:mibolsillo/core/preferences/app_preferences.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sesión ficticia para probar las pantallas internas sin red.
class _FakeSessionController extends SessionController {
  @override
  Session? build() {
    return Session(
      accessToken: 'token-de-prueba',
      tokenType: 'bearer',
      user: User(
        id: 'usuario-de-prueba',
        appMetadata: const {},
        userMetadata: const {'full_name': 'Prueba'},
        aud: 'authenticated',
        email: 'prueba@correo.com',
        createdAt: '2026-01-01T00:00:00Z',
      ),
    );
  }
}

Future<Widget> _buildApp({
  Map<String, Object> values = const {},
  bool signedIn = false,
}) async {
  SharedPreferences.setMockInitialValues(values);
  final preferences = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      if (signedIn) sessionProvider.overrideWith(_FakeSessionController.new),
    ],
    child: const MiBolsilloApp(),
  );
}

void main() {
  testWidgets('sin sesión la app abre el acceso', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Balance total'), findsNothing);
  });

  testWidgets('con sesión y sin tutorial aparece el tutorial', (tester) async {
    await tester.pumpWidget(await _buildApp(signedIn: true));
    await tester.pumpAndSettle();

    expect(find.text('Todo tu dinero, en un solo lugar'), findsOneWidget);
    expect(find.text('Paso 1 de 4'), findsOneWidget);
  });

  testWidgets('completar el tutorial lleva al inicio vacío', (tester) async {
    await tester.pumpWidget(await _buildApp(signedIn: true));
    await tester.pumpAndSettle();

    for (var step = 0; step < 3; step++) {
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Paso 4 de 4'), findsOneWidget);
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();

    expect(find.text('Balance total'), findsOneWidget);
    expect(find.text('Aún no tienes cuentas'), findsOneWidget);
  });

  testWidgets('el inicio no muestra datos de prueba', (tester) async {
    await tester.pumpWidget(
      await _buildApp(values: {'onboarding_completed': true}, signedIn: true),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aún no tienes cuentas'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Sin movimientos todavía'), findsOneWidget);
    expect(find.text('Almuerzo con equipo'), findsNothing);
    expect(find.text('RD\$ 86,050'), findsNothing);
  });
}
