// Archivo: test/accounts_screen_test.dart
//
// Pruebas de la pantalla "Cuentas y metas". Se sustituyen los providers de
// cuentas y metas por datos fijos para no depender de Supabase.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/accounts/application/accounts_providers.dart';
import 'package:mibolsillo/features/accounts/data/account.dart';
import 'package:mibolsillo/features/accounts/data/accounts_repository.dart';
import 'package:mibolsillo/features/accounts/presentation/accounts_screen.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/goals/application/goals_providers.dart';
import 'package:mibolsillo/features/goals/data/goals_repository.dart';
import 'package:mibolsillo/features/goals/data/savings_goal.dart';
import 'package:mibolsillo/l10n/generated/app_localizations.dart';

/// Cuenta de prueba.
const _account = AccountSummary(
  id: 'cuenta-efectivo',
  name: 'Efectivo',
  kind: AccountKind.efectivo,
  balance: 1500,
);

/// Meta de prueba con la mitad ahorrada.
const _goal = SavingsGoal(
  id: 'meta-vacaciones',
  name: 'Vacaciones',
  targetAmount: 1000,
  saved: 500,
);

/// Construye la pantalla con datos falsos y la nube desactivada.
Widget _buildScreen({
  List<AccountSummary> accounts = const [_account],
  List<SavingsGoal> goals = const [_goal],
  bool accountsFail = false,
  bool goalsFail = false,
}) {
  return ProviderScope(
    overrides: [
      supabaseClientProvider.overrideWithValue(null),
      accountsProvider.overrideWith((ref) async {
        if (accountsFail) {
          throw const AccountsFailure(AccountsError.load);
        }
        return accounts;
      }),
      goalsProvider.overrideWith((ref) async {
        if (goalsFail) {
          throw const GoalsFailure(GoalsError.load);
        }
        return goals;
      }),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AccountsScreen(),
    ),
  );
}

/// Agranda la superficie para que quepan las dos secciones en la prueba.
void _useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('muestra cuentas y metas con su progreso', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Cuentas y metas'), findsOneWidget);
    expect(find.text('Efectivo'), findsOneWidget);
    expect(find.text('Vacaciones'), findsOneWidget);
    expect(find.text('Ahorrado: RD\$ 500.00 de RD\$ 1,000.00'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Faltan RD\$ 500.00'), findsOneWidget);
    expect(find.text('Crear meta'), findsOneWidget);
  });

  testWidgets('sin metas invita a crear la primera', (tester) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_buildScreen(goals: const []));
    await tester.pumpAndSettle();

    expect(find.text('Aún no tienes metas'), findsOneWidget);
    // El encabezado y el estado vacío ofrecen la misma acción.
    expect(find.text('Crear meta'), findsNWidgets(2));
  });

  testWidgets('sin cuentas invita a configurar el saldo inicial', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_buildScreen(accounts: const []));
    await tester.pumpAndSettle();

    expect(find.text('Aún no tienes cuentas'), findsOneWidget);
    expect(find.text('Configurar saldo inicial'), findsOneWidget);
  });

  testWidgets('muestra un error de metas con opción de reintentar', (
    tester,
  ) async {
    _useTallScreen(tester);
    await tester.pumpWidget(_buildScreen(goalsFail: true));
    await tester.pumpAndSettle();

    expect(
      find.text('No pudimos cargar tus metas. Revisa tu conexión.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
