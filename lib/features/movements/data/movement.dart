import 'package:flutter/foundation.dart';

import '../../categories/data/category.dart';

/// Tipos que se pueden registrar en esta entrega. `ahorro` llega con las metas.
enum MovementType {
  gasto('Gasto', 'Guardar gasto', CategoryKind.gasto),
  ingreso('Ingreso', 'Guardar ingreso', CategoryKind.ingreso);

  const MovementType(this.label, this.saveLabel, this.categoryKind);

  final String label;
  final String saveLabel;
  final CategoryKind categoryKind;
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
