// Archivo: test/savings_goal_test.dart
//
// Pruebas del modelo de meta de ahorro: cálculo de progreso y lectura de la
// vista `goal_balances`.

import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/features/goals/data/savings_goal.dart';

void main() {
  test('calcula lo que falta y el progreso', () {
    const goal = SavingsGoal(
      id: 'meta-1',
      name: 'Viaje',
      targetAmount: 1000,
      saved: 250,
    );

    expect(goal.remaining, 750);
    expect(goal.progress, 0.25);
    expect(goal.isComplete, isFalse);
  });

  test('no pasa del 100% ni deja un saldo negativo', () {
    const goal = SavingsGoal(
      id: 'meta-2',
      name: 'Fondo',
      targetAmount: 1000,
      saved: 1200,
    );

    expect(goal.remaining, 0);
    expect(goal.progress, 1);
    expect(goal.isComplete, isTrue);
  });

  test('fromMap lee la fila de goal_balances', () {
    final goal = SavingsGoal.fromMap({
      'id': 'meta-3',
      'name': 'Emergencias',
      'target_amount': 500.5,
      'saved': 100,
      'target_date': '2027-01-15',
    });

    expect(goal.id, 'meta-3');
    expect(goal.name, 'Emergencias');
    expect(goal.targetAmount, 500.5);
    expect(goal.saved, 100);
    expect(goal.targetDate, DateTime(2027, 1, 15));
  });

  test('fromMap admite una meta sin ahorro ni fecha', () {
    final goal = SavingsGoal.fromMap({
      'id': 'meta-4',
      'name': 'Computadora',
      'target_amount': 2000,
      'saved': null,
      'target_date': null,
    });

    expect(goal.saved, 0);
    expect(goal.targetDate, isNull);
    expect(goal.remaining, 2000);
  });
}
