// Archivo: test/movement_test.dart
//
// Pruebas del modelo de movimientos, en especial la lectura de un ahorro con
// su meta desde una fila de Supabase.

import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/features/movements/data/movement.dart';

void main() {
  test('fromMap lee un ahorro y su meta', () {
    final movement = MovementEntry.fromMap({
      'id': 'movimiento-1',
      'type': 'ahorro',
      'amount': 300,
      'occurred_on': '2026-11-06',
      'note': 'Mensual',
      'accounts': {'name': 'Banco'},
      'categories': null,
      'goals': {'name': 'Vacaciones'},
    });

    expect(movement.type, MovementType.ahorro);
    expect(movement.amount, 300);
    expect(movement.accountName, 'Banco');
    expect(movement.category, isNull);
    expect(movement.goalName, 'Vacaciones');
    // El ahorro sale del saldo disponible de la cuenta.
    expect(movement.signedAmount, -300);
    expect(movement.isIncome, isFalse);
  });

  test('fromMap mantiene los gastos e ingresos como antes', () {
    final income = MovementEntry.fromMap({
      'id': 'movimiento-2',
      'type': 'ingreso',
      'amount': 12000,
      'occurred_on': '2026-11-06',
      'accounts': {'name': 'Banco'},
      'categories': null,
      'goals': null,
    });

    expect(income.type, MovementType.ingreso);
    expect(income.isIncome, isTrue);
    expect(income.signedAmount, 12000);
    expect(income.goalName, isNull);
  });

  test('fromDb acepta los tres tipos', () {
    expect(MovementType.fromDb('gasto'), MovementType.gasto);
    expect(MovementType.fromDb('ingreso'), MovementType.ingreso);
    expect(MovementType.fromDb('ahorro'), MovementType.ahorro);
  });
}
