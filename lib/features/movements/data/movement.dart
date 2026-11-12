// Archivo: lib/features/movements/data/movement.dart
//
// Modelos de movimientos: tipos permitidos, datos para crear uno y datos ya
// guardados listos para la lista.
//
// Un ahorro es un movimiento especial: descuenta de la cuenta y suma a una
// meta. Por eso exige `goalId` y no admite categoría.

import 'package:flutter/foundation.dart' show immutable;

import '../../categories/data/category.dart';

/// Tipos de movimiento que entiende la app.
///
/// Cada tipo conoce qué categorías se ofrecen en el formulario. El ahorro no
/// usa categorías: usa una meta. Los textos visibles se resuelven en la capa de
/// presentación con `MovementTypeLabel`.
enum MovementType {
  gasto(CategoryKind.gasto),
  ingreso(CategoryKind.ingreso),
  ahorro(null);

  const MovementType(this.categoryKind);

  /// Tipo de categoría que acepta el movimiento; `null` para el ahorro.
  final CategoryKind? categoryKind;

  /// Convierte el valor almacenado en la base a un [MovementType].
  static MovementType fromDb(String value) {
    return switch (value) {
      'gasto' => MovementType.gasto,
      'ingreso' => MovementType.ingreso,
      'ahorro' => MovementType.ahorro,
      _ => throw FormatException('Tipo de movimiento no soportado: $value'),
    };
  }
}

/// Datos mínimos para insertar un movimiento.
@immutable
class MovementDraft {
  const MovementDraft({
    required this.type,
    required this.amount,
    required this.occurredOn,
    required this.accountId,
    this.categoryId,
    this.goalId,
    this.note,
  });

  final MovementType type;
  final double amount;
  final DateTime occurredOn;
  final String accountId;

  /// Solo para gastos e ingresos.
  final String? categoryId;

  /// Solo para ahorros.
  final String? goalId;
  final String? note;
}

/// Movimiento ya guardado, con los datos que necesita la lista.
@immutable
class MovementEntry {
  const MovementEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.occurredOn,
    this.accountId,
    this.accountName,
    this.note,
    this.category,
    this.goalName,
  });

  final String id;
  final MovementType type;
  final double amount;
  final DateTime occurredOn;
  final String? accountId;

  /// Nombre de la cuenta asociada; `null` si la relación no vino en la fila.
  final String? accountName;
  final String? note;
  final Category? category;

  /// Nombre de la meta cuando el movimiento es un ahorro.
  final String? goalName;

  bool get isIncome => type == MovementType.ingreso;

  /// Importe con signo para mostrarlo en la lista.
  ///
  /// El ingreso suma; el gasto y el ahorro restan de la cuenta. El ahorro no es
  /// una pérdida: el dinero pasa a la meta, pero sale del saldo disponible.
  double get signedAmount => isIncome ? amount : -amount;

  /// Construye un movimiento a partir de una fila de Supabase con las
  /// relaciones `accounts(...)`, `categories(...)` y `goals(...)` ya incluidas.
  ///
  /// Las fechas se normalizan a medianoche (`_dateOnly`) para agrupar por día
  /// sin que la hora afecte la comparación.
  factory MovementEntry.fromMap(Map<String, dynamic> map) {
    final note = (map['note'] as String?)?.trim();
    final category = map['categories'];
    final account = map['accounts'];
    final goal = map['goals'];

    return MovementEntry(
      id: map['id'] as String,
      type: MovementType.fromDb(map['type'] as String),
      amount: (map['amount'] as num).toDouble(),
      occurredOn: _dateOnly(DateTime.parse(map['occurred_on'] as String)),
      accountId: map['account_id'] as String?,
      accountName: account is Map<String, dynamic>
          ? account['name'] as String?
          : null,
      note: (note == null || note.isEmpty) ? null : note,
      category: category is Map<String, dynamic>
          ? Category.fromMap(category)
          : null,
      goalName: goal is Map<String, dynamic> ? goal['name'] as String? : null,
    );
  }
}

/// Ingresos y gastos de un mes, sin contar ahorros.
///
/// Los ahorros no son un gasto: solo mueven dinero de una cuenta a una meta.
@immutable
class MovementTotals {
  const MovementTotals({required this.income, required this.expenses});

  final double income;
  final double expenses;

  static const zero = MovementTotals(income: 0, expenses: 0);
}

/// Quita la hora de una fecha para comparar solo el día.
DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
