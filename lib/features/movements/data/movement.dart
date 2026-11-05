// Archivo: lib/features/movements/data/movement.dart
//
// Modelos de movimientos: tipos permitidos, datos para crear uno y datos ya
// guardados listos para la lista. Los ahorros se incorporarán en la Parte 3.

import 'package:flutter/foundation.dart' show immutable;

import '../../categories/data/category.dart';

/// Tipos que se pueden registrar en esta entrega. `ahorro` llega con las metas.
///
/// Cada tipo conoce:
/// - `label`: texto singular para el usuario.
/// - `saveLabel`: texto del botón de guardado.
/// - `categoryKind`: qué categorías se ofrecen en el formulario.
enum MovementType {
  gasto('Gasto', 'Guardar gasto', CategoryKind.gasto),
  ingreso('Ingreso', 'Guardar ingreso', CategoryKind.ingreso);

  const MovementType(this.label, this.saveLabel, this.categoryKind);

  final String label;
  final String saveLabel;
  final CategoryKind categoryKind;

  /// Convierte el valor almacenado en la base a un [MovementType].
  static MovementType fromDb(String value) {
    return switch (value) {
      'gasto' => MovementType.gasto,
      'ingreso' => MovementType.ingreso,
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
    this.note,
  });

  final MovementType type;
  final double amount;
  final DateTime occurredOn;
  final String accountId;
  final String? categoryId;
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
    required this.accountName,
    this.note,
    this.category,
  });

  final String id;
  final MovementType type;
  final double amount;
  final DateTime occurredOn;
  final String accountName;
  final String? note;
  final Category? category;

  bool get isIncome => type == MovementType.ingreso;

  /// Importe con signo para mostrarlo en la lista: ingreso positivo, gasto
  /// negativo.
  double get signedAmount => isIncome ? amount : -amount;

  /// Construye un movimiento a partir de una fila de Supabase con las
  /// relaciones `accounts(...)` y `categories(...)` ya incluidas.
  ///
  /// Las fechas se normalizan a medianoche (`_dateOnly`) para agrupar por día
  /// sin que la hora afecte la comparación.
  factory MovementEntry.fromMap(Map<String, dynamic> map) {
    final note = (map['note'] as String?)?.trim();
    final category = map['categories'];
    final account = map['accounts'];

    return MovementEntry(
      id: map['id'] as String,
      type: MovementType.fromDb(map['type'] as String),
      amount: (map['amount'] as num).toDouble(),
      occurredOn: _dateOnly(DateTime.parse(map['occurred_on'] as String)),
      accountName: account is Map<String, dynamic>
          ? account['name'] as String? ?? 'Cuenta'
          : 'Cuenta',
      note: (note == null || note.isEmpty) ? null : note,
      category: category is Map<String, dynamic>
          ? Category.fromMap(category)
          : null,
    );
  }
}

/// Ingresos y gastos de un mes, sin contar ahorros.
@immutable
class MovementTotals {
  const MovementTotals({required this.income, required this.expenses});

  final double income;
  final double expenses;

  static const zero = MovementTotals(income: 0, expenses: 0);
}

/// Quita la hora de una fecha para comparar solo el día.
DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
