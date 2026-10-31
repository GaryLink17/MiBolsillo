import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/app.dart';
import 'package:mibolsillo/core/preferences/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _buildApp({Map<String, Object> values = const {}}) async {
  SharedPreferences.setMockInitialValues(values);
  final preferences = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    child: const MiBolsilloApp(),
  );
}

void main() {
  testWidgets('la primera vez muestra el tutorial guiado', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Todo tu dinero, en un solo lugar'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
    expect(find.text('Paso 1 de 4'), findsOneWidget);
  });

  testWidgets('completar el tutorial lleva al inicio', (tester) async {
    await tester.pumpWidget(await _buildApp());
    await tester.pumpAndSettle();

    for (var step = 0; step < 3; step++) {
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Paso 4 de 4'), findsOneWidget);
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();

    expect(find.text('Balance total'), findsOneWidget);
    expect(find.text('Mis cuentas'), findsOneWidget);
  });

  testWidgets('si el tutorial ya se vio, abre directo el inicio', (
    tester,
  ) async {
    await tester.pumpWidget(
      await _buildApp(values: {'onboarding_completed': true}),
    );
    await tester.pumpAndSettle();

    expect(find.text('Balance total'), findsOneWidget);
    expect(find.text('Ingresos'), findsOneWidget);
  });
}
