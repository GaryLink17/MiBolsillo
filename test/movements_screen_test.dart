// Archivo: test/movements_screen_test.dart
//
// Pruebas de la pantalla Movimientos y de la sección de recientes en Inicio.
// Se sustituyen los providers de datos por listas y totales fijos para no
// depender de la red.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_colors.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/accounts/application/accounts_providers.dart';
import 'package:mibolsillo/features/accounts/data/account.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/categories/data/category.dart';
import 'package:mibolsillo/features/goals/application/goals_providers.dart';
import 'package:mibolsillo/features/goals/data/savings_goal.dart';
import 'package:mibolsillo/features/home/presentation/home_screen.dart';
import 'package:mibolsillo/features/movements/application/movements_providers.dart';
import 'package:mibolsillo/features/movements/data/movement.dart';
import 'package:mibolsillo/features/movements/data/movements_repository.dart';
import 'package:mibolsillo/features/movements/presentation/movement_row.dart';
import 'package:mibolsillo/features/movements/presentation/movements_screen.dart';
import 'package:mibolsillo/l10n/generated/app_localizations.dart';
import 'package:mibolsillo/shared/widgets/money_text.dart';
import 'package:mibolsillo/shared/widgets/movement_tile.dart';

/// Categoría de gasto de prueba.
const _comida = Category(
  id: 'categoria-comida',
  name: 'Comida',
  kind: CategoryKind.gasto,
  tone: CategoryTone.food,
  icon: Icons.restaurant_rounded,
);

/// Categoría de ingreso de prueba.
const _salario = Category(
  id: 'categoria-salario',
  name: 'Salario',
  kind: CategoryKind.ingreso,
  tone: CategoryTone.income,
  icon: Icons.payments_rounded,
);

/// Cuenta de prueba.
const _account = AccountSummary(
  id: 'cuenta-efectivo',
  name: 'Efectivo',
  kind: AccountKind.efectivo,
  balance: 1500,
);

/// Construye la pantalla Movimientos con datos falsos.
///
/// Con `fails: true` el provider lanza un error para probar el estado de error.
Widget _buildMovements({
  List<MovementEntry> movements = const [],
  bool fails = false,
}) {
  return ProviderScope(
    overrides: [
      supabaseClientProvider.overrideWithValue(null),
      movementsProvider.overrideWith((ref) async {
        if (fails) {
          throw const MovementsFailure(MovementsError.load);
        }
        return movements;
      }),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MovementsScreen(),
    ),
  );
}

/// Construye Inicio con cuentas, movimientos y totales controlados.
Widget _buildHome({
  required List<MovementEntry> movements,
  required MovementTotals totals,
  List<SavingsGoal> goals = const [],
}) {
  return ProviderScope(
    overrides: [
      supabaseClientProvider.overrideWithValue(null),
      accountsProvider.overrideWith((ref) async => const [_account]),
      goalsProvider.overrideWith((ref) async => goals),
      movementsProvider.overrideWith((ref) async => movements),
      monthlyTotalsProvider.overrideWith((ref) async => totals),
    ],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  testWidgets(
    'los filtros tienen separación y muestran el contador al cerrar',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _buildMovements(
          movements: [
            MovementEntry(
              id: '1',
              type: MovementType.gasto,
              amount: 10,
              occurredOn: DateTime.now(),
              accountId: 'a',
              accountName: 'Banco',
              category: _comida,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();
      final type = find.byType(DropdownButtonFormField<MovementType>);
      final fields = find.byType(DropdownButtonFormField<String>);
      expect(
        tester.getBottomLeft(type).dy,
        lessThan(tester.getTopLeft(fields.first).dy),
      );
      expect(
        tester.getBottomLeft(fields.first).dy,
        lessThan(tester.getTopLeft(fields.last).dy),
      );
      tester.widget<DropdownButtonFormField<MovementType>>(type).onChanged!(
        MovementType.gasto,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Filtros'));
      await tester.tap(find.text('Filtros'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(ExpansionTile),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('combina cuenta y categoría por sus identificadores', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final today = DateTime.now();
    await tester.pumpWidget(
      _buildMovements(
        movements: [
          MovementEntry(
            id: '1',
            type: MovementType.gasto,
            amount: 10,
            occurredOn: today,
            accountId: 'a',
            accountName: 'Banco',
            category: _comida,
          ),
          MovementEntry(
            id: '2',
            type: MovementType.gasto,
            amount: 20,
            occurredOn: today,
            accountId: 'b',
            accountName: 'Banco',
            category: _comida,
          ),
          MovementEntry(
            id: '3',
            type: MovementType.ingreso,
            amount: 30,
            occurredOn: today,
            accountId: 'a',
            accountName: 'Banco',
            category: _salario,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();
    var dropdowns = tester
        .widgetList<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        )
        .toList();
    dropdowns[0].onChanged!('a');
    await tester.pumpAndSettle();
    dropdowns = tester
        .widgetList<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        )
        .toList();
    dropdowns[1].onChanged!('categoria-comida');
    await tester.pumpAndSettle();
    final rows = tester
        .widgetList<MovementRow>(find.byType(MovementRow))
        .toList();
    expect(rows.map((row) => row.movement.id), ['1']);
  });

  testWidgets('busca nombres y notas y permite limpiar los resultados', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final today = DateTime.now();
    await tester.pumpWidget(
      _buildMovements(
        movements: [
          MovementEntry(
            id: '1',
            type: MovementType.ahorro,
            amount: 10,
            occurredOn: today,
            accountId: 'a',
            accountName: 'Banco',
            goalName: 'Vacaciones',
            note: 'Mensual',
          ),
          MovementEntry(
            id: '2',
            type: MovementType.gasto,
            amount: 20,
            occurredOn: today,
            accountId: 'b',
            accountName: 'Efectivo',
            category: _comida,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    final search = find.byKey(const ValueKey('movements-search'));
    for (final query in ['VACACIONES', 'mensual', 'banco']) {
      await tester.enterText(search, query);
      await tester.pumpAndSettle();
      expect(find.byType(MovementRow), findsOneWidget);
      expect(find.text('Vacaciones'), findsOneWidget);
    }
    await tester.enterText(search, 'comida');
    await tester.pumpAndSettle();
    expect(find.text('Comida'), findsOneWidget);
    await tester.enterText(search, 'inexistente');
    await tester.pumpAndSettle();
    expect(find.text('Sin resultados'), findsOneWidget);
    await tester.tap(find.text('Limpiar filtros'));
    await tester.pumpAndSettle();
    expect(find.byType(MovementRow), findsNWidgets(2));
  });

  testWidgets('combina filtro de tipo con búsqueda', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final today = DateTime.now();
    await tester.pumpWidget(
      _buildMovements(
        movements: [
          MovementEntry(
            id: '1',
            type: MovementType.ahorro,
            amount: 10,
            occurredOn: today,
            accountId: 'a',
            accountName: 'Banco',
            goalName: 'Viaje',
          ),
          MovementEntry(
            id: '2',
            type: MovementType.gasto,
            amount: 20,
            occurredOn: today,
            accountId: 'a',
            accountName: 'Banco',
            note: 'Taxi',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('movements-search')),
      'banco',
    );
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<MovementType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ahorro').last);
    await tester.pumpAndSettle();
    expect(find.byType(MovementRow), findsOneWidget);
    expect(find.text('Viaje'), findsOneWidget);
  });

  testWidgets('sin movimientos invita a registrar el primero', (tester) async {
    await tester.pumpWidget(_buildMovements());
    await tester.pumpAndSettle();

    expect(find.text('Movimientos'), findsOneWidget);
    expect(find.text('Sin movimientos todavía'), findsOneWidget);
    expect(find.text('Registrar el primero'), findsOneWidget);
  });

  testWidgets('agrupa por Hoy y Ayer y muestra los signos', (tester) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    await tester.pumpWidget(
      _buildMovements(
        movements: [
          MovementEntry(
            id: '1',
            type: MovementType.ingreso,
            amount: 12000,
            occurredOn: today,
            accountName: 'Banco',
            category: _salario,
          ),
          MovementEntry(
            id: '2',
            type: MovementType.gasto,
            amount: 450,
            occurredOn: today,
            accountName: 'Efectivo',
            category: _comida,
          ),
          MovementEntry(
            id: '3',
            type: MovementType.gasto,
            amount: 120,
            occurredOn: yesterday,
            accountName: 'Efectivo',
            note: 'Taxi',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Encabezados de día y títulos de cada fila.
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.text('Ayer'), findsOneWidget);
    expect(find.text('Salario'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.byType(MovementRow), findsNWidgets(3));

    // Los importes llegan a la fila con signo: gasto negativo, ingreso
    // positivo.
    final amounts = tester
        .widgetList<MovementTile>(find.byType(MovementTile))
        .map((tile) => tile.amount);
    expect(amounts, containsAll(<double>[-450, 12000, -120]));
  });

  testWidgets('muestra un error con opción de reintentar', (tester) async {
    await tester.pumpWidget(_buildMovements(fails: true));
    await tester.pumpAndSettle();

    expect(
      find.text('No pudimos cargar tus movimientos. Revisa tu conexión.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('Inicio muestra los totales reales y solo 5 recientes', (
    tester,
  ) async {
    // Se agranda la superficie para que Inicio quepa completo.
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final today = DateUtils.dateOnly(DateTime.now());
    final movements = [
      for (var index = 0; index < 6; index++)
        MovementEntry(
          id: '$index',
          type: MovementType.gasto,
          amount: (10 + index).toDouble(),
          occurredOn: today,
          accountName: 'Efectivo',
          category: _comida,
        ),
    ];

    await tester.pumpWidget(
      _buildHome(
        movements: movements,
        totals: const MovementTotals(income: 12000, expenses: 450),
      ),
    );
    await tester.pumpAndSettle();

    // Hay 6 movimientos, pero Inicio solo muestra 5 y el botón "Ver todos".
    expect(find.text('Movimientos recientes'), findsOneWidget);
    expect(find.text('Ver todos'), findsOneWidget);
    expect(find.byType(MovementRow), findsNWidgets(5));

    // Los totales del mes llegan a las tarjetas de Ingresos y Gastos.
    final amounts = tester
        .widgetList<MoneyText>(find.byType(MoneyText))
        .map((money) => money.amount);
    expect(amounts, containsAll(<double>[12000, 450]));
  });

  testWidgets('muestra el ahorro con su meta y signo negativo', (tester) async {
    final today = DateUtils.dateOnly(DateTime.now());

    await tester.pumpWidget(
      _buildMovements(
        movements: [
          MovementEntry(
            id: 'ahorro-1',
            type: MovementType.ahorro,
            amount: 300,
            occurredOn: today,
            accountName: 'Banco',
            goalName: 'Vacaciones',
            note: 'Mensual',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vacaciones'), findsOneWidget);
    expect(find.text('Ahorro · Mensual · Banco'), findsOneWidget);

    // El ahorro sale de la cuenta: se muestra en negativo.
    final amounts = tester
        .widgetList<MovementTile>(find.byType(MovementTile))
        .map((tile) => tile.amount);
    expect(amounts, contains(-300));
  });

  testWidgets('el balance total suma lo ahorrado en las metas', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _buildHome(
        movements: const [],
        totals: MovementTotals.zero,
        goals: const [
          SavingsGoal(
            id: 'meta-1',
            name: 'Vacaciones',
            targetAmount: 1000,
            saved: 250,
          ),
          SavingsGoal(
            id: 'meta-2',
            name: 'Fondo',
            targetAmount: 2000,
            saved: 500,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // 1,500 de la cuenta + 750 ahorrados en las metas.
    final amounts = tester
        .widgetList<MoneyText>(find.byType(MoneyText))
        .map((money) => money.amount);
    expect(amounts, contains(2250));
  });
}
