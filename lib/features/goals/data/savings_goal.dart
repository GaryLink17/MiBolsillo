// Archivo: lib/features/goals/data/savings_goal.dart
//
// Modelo de una meta de ahorro. Los datos vienen de la vista
// `goal_balances`, que ya calcula cuánto se ha ahorrado en cada meta.

import 'package:flutter/foundation.dart' show immutable;

/// Meta de ahorro con su progreso calculado.
@immutable
class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.saved,
    this.targetDate,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double saved;
  final DateTime? targetDate;

  /// Lo que falta para llegar a la meta. Nunca es negativo.
  double get remaining {
    final value = targetAmount - saved;
    return value > 0 ? value : 0;
  }

  /// Progreso entre 0 y 1. Se usa para la barra visual.
  double get progress {
    if (targetAmount <= 0) return 0;
    return (saved / targetAmount).clamp(0.0, 1.0);
  }

  bool get isComplete => saved >= targetAmount;

  /// Convierte una fila de `goal_balances` en una meta.
  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    final targetDate = map['target_date'] as String?;

    return SavingsGoal(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      saved: (map['saved'] as num?)?.toDouble() ?? 0,
      targetDate: targetDate == null ? null : DateTime.parse(targetDate),
    );
  }
}

/// Datos mínimos para crear una meta.
@immutable
class GoalDraft {
  const GoalDraft({
    required this.name,
    required this.targetAmount,
    this.targetDate,
  });

  final String name;
  final double targetAmount;
  final DateTime? targetDate;
}
