// Archivo: test/new_movement_screen_test.dart
//
// Pruebas del formulario de gasto/ingreso. Se inyectan cuentas y categorías
// falsas mediante providers para no depender de Supabase.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_colors.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/accounts/application/accounts_providers.dart';
import 'package:mibolsillo/features/accounts/data/account.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/categories/application/categories_providers.dart';
import 'package:mibolsillo/features/categories/data/category.dart';
import 'package:mibolsillo/features/movements/presentation/new_movement_screen.dart';
import 'package:mibolsillo/l10n/generated/app_localizations.dart';

/// Cuenta de prueba con saldo conocido.
const _accounts = [
  AccountSummary(
    id: 'cuenta-efectivo',
    name: 'Efectivo',
    kind: AccountKind.efectivo,
    balance: 1500,
  ),
];

/// Una categoría de gasto y otra de ingreso para comprobar el filtrado.
const _categories = [
  Category(
    id: 'categoria-comida',
    name: 'Comida',
    kind: CategoryKind.gasto,
    tone: CategoryTone.food,
    icon: Icons.restaurant_rounded,
  ),
  Category(
    id: 'categoria-salario',
    name: 'Salario',
    kind: CategoryKind.ingreso,
    tone: CategoryTone.income,
    icon: Icons.payments_rounded,
  ),
];

/// Construye la pantalla con datos falsos y la nube desactivada.
Widget _buildScreen({
  List<AccountSummary> accounts = _accounts,
  List<Category> categories = _categories,
}) {
  return ProviderScope(
    overrides: [
      supabaseClientProvider.overrideWithValue(null),
      accountsProvider.overrideWith((ref) async => accounts),
      categoriesProvider.overrideWith((ref) async => categories),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const NewMovementScreen(),
    ),
  );
}

/// Desplaza hasta el botón de guardado y lo pulsa.
///
/// Es necesario porque el formulario es largo y el botón puede quedar fuera de
/// la pantalla en el entorno de pruebas.
Future<void> _tapSave(WidgetTester tester, String label) async {
  final finder = find.text(label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('abre en gasto con la cuenta disponible', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Nuevo movimiento'), findsOneWidget);
    expect(find.text('Guardar gasto'), findsOneWidget);
    expect(find.text('Efectivo · RD\$ 1,500.00'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
  });

  testWidgets('cambiar a ingreso cambia el botón y filtra categorías', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ingreso'));
    await tester.pumpAndSettle();

    expect(find.text('Guardar ingreso'), findsOneWidget);
    expect(find.text('Salario'), findsOneWidget);
    expect(find.text('Comida'), findsNothing);
  });

  testWidgets('exige una cuenta antes de guardar', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('movement-amount')),
      '100',
    );
    await _tapSave(tester, 'Guardar gasto');

    expect(
      find.text('Elige la cuenta de donde sale el dinero.'),
      findsOneWidget,
    );
  });

  testWidgets('rechaza un monto en cero', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('movement-amount')), '0');
    await _tapSave(tester, 'Guardar gasto');

    expect(find.text('El monto debe ser mayor que cero.'), findsOneWidget);
  });

  testWidgets('avisa cuando la nube no está configurada', (tester) async {
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    // Con monto y cuenta válidos, el flujo llega al repositorio nulo.
    await tester.enterText(
      find.byKey(const ValueKey('movement-amount')),
      '100',
    );
    await tester.tap(find.text('Efectivo · RD\$ 1,500.00'));
    await tester.pumpAndSettle();
    await _tapSave(tester, 'Guardar gasto');

    expect(
      find.text('La nube no está configurada en esta versión.'),
      findsOneWidget,
    );
  });

  testWidgets('sin cuentas invita a configurar el saldo inicial', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen(accounts: const []));
    await tester.pumpAndSettle();

    expect(find.text('Primero configura tu saldo inicial'), findsOneWidget);
    expect(find.text('Configurar saldo inicial'), findsOneWidget);
  });
}
