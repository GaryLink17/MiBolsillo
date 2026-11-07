// Archivo: test/new_goal_screen_test.dart
//
// Pruebas del formulario de creación de metas. La nube se desactiva para que
// las pruebas no dependan de Supabase.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/goals/presentation/new_goal_screen.dart';
import 'package:mibolsillo/l10n/generated/app_localizations.dart';

/// Construye el formulario con la nube desactivada.
Widget _buildScreen() {
  return ProviderScope(
    overrides: [supabaseClientProvider.overrideWithValue(null)],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const NewGoalScreen(),
    ),
  );
}

/// Desplaza hasta el botón de guardado y lo pulsa.
Future<void> _tapSave(WidgetTester tester) async {
  final finder = find.text('Guardar meta');
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('abre con nombre, monto y fecha opcional', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Nueva meta'), findsOneWidget);
    expect(find.text('Nombre de la meta'), findsOneWidget);
    expect(find.text('Monto objetivo'), findsOneWidget);
    expect(find.text('Sin fecha'), findsOneWidget);
    expect(find.text('Guardar meta'), findsOneWidget);
  });

  testWidgets('exige nombre y monto antes de guardar', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await _tapSave(tester);

    expect(find.text('Escribe un nombre para la meta.'), findsOneWidget);
    expect(find.text('Escribe el monto objetivo.'), findsOneWidget);
  });

  testWidgets('rechaza un monto en cero', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('goal-name')), 'Viaje');
    await tester.enterText(find.byKey(const ValueKey('goal-target')), '0');
    await _tapSave(tester);

    expect(find.text('El monto debe ser mayor que cero.'), findsOneWidget);
  });

  testWidgets('avisa cuando la nube no está configurada', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('goal-name')),
      'Fondo de emergencia',
    );
    await tester.enterText(find.byKey(const ValueKey('goal-target')), '25000');
    await _tapSave(tester);

    expect(
      find.text('La nube no está configurada en esta versión.'),
      findsOneWidget,
    );
  });
}
