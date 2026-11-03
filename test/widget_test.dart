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

Future<void> _tapVisible(WidgetTester tester, String label) async {
  final finder = find.text(label);
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      220,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sin sesión la app abre la bienvenida', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Mi Bolsillo'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
    expect(find.text('Ya tengo cuenta'), findsOneWidget);
    expect(find.text('Balance total'), findsNothing);
  });

  testWidgets('"Ya tengo cuenta" lleva al acceso', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Ya tengo cuenta');

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('"Comenzar" lleva al tutorial', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Comenzar');

    expect(find.text('Todo tu dinero, en un solo lugar'), findsOneWidget);
    expect(find.text('Paso 1 de 4'), findsOneWidget);
  });

  testWidgets('terminar el tutorial sin sesión lleva al acceso', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Comenzar');
    for (var step = 0; step < 3; step++) {
      await _tapVisible(tester, 'Siguiente');
    }

    expect(find.text('Paso 4 de 4'), findsOneWidget);
    await _tapVisible(tester, 'Empezar');

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
  });

  testWidgets('con sesión y sin tutorial aparece el tutorial', (tester) async {
    await tester.pumpWidget(await _buildApp(signedIn: true));
    await tester.pumpAndSettle();

    expect(find.text('Todo tu dinero, en un solo lugar'), findsOneWidget);
    expect(find.text('Paso 1 de 4'), findsOneWidget);
  });

  testWidgets('completar el tutorial con sesión lleva al saldo inicial', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp(signedIn: true));
    await tester.pumpAndSettle();

    for (var step = 0; step < 3; step++) {
      await _tapVisible(tester, 'Siguiente');
    }
    await _tapVisible(tester, 'Empezar');

    expect(find.text('¿Con cuánto empiezas?'), findsOneWidget);
    expect(find.text('Efectivo'), findsOneWidget);
    expect(find.text('Banco'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tarjeta'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Ahorros'), findsOneWidget);
    expect(find.text('Tarjeta'), findsOneWidget);
  });

  testWidgets('desde el saldo inicial se puede omitir e ir al inicio', (
    tester,
  ) async {
    await tester.pumpWidget(await _buildApp(signedIn: true));
    await tester.pumpAndSettle();

    for (var step = 0; step < 3; step++) {
      await _tapVisible(tester, 'Siguiente');
    }
    await _tapVisible(tester, 'Empezar');
    await _tapVisible(tester, 'Lo hago después');

    expect(find.text('Balance total'), findsOneWidget);
    expect(find.text('Aún no tienes cuentas'), findsOneWidget);
  });

  testWidgets('el saldo inicial exige al menos una cuenta activa', (
    tester,
  ) async {
    await tester.pumpWidget(
      await _buildApp(values: {'onboarding_completed': true}, signedIn: true),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Configurar saldo inicial');

    expect(find.text('¿Con cuánto empiezas?'), findsOneWidget);

    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byType(Switch).at(i));
      await tester.pumpAndSettle();
    }

    await _tapVisible(tester, 'Empezar');
    expect(find.text('Activa al menos una cuenta.'), findsOneWidget);
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
