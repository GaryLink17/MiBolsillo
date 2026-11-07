// Archivo: lib/features/movements/presentation/movement_row.dart
//
// Adapta un `MovementEntry` al widget visual `MovementTile`. Se usa tanto en
// Inicio (últimos 5) como en la pantalla Movimientos.

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/movement_tile.dart';
import '../../categories/presentation/category_labels.dart';
import '../data/movement.dart';
import 'movement_labels.dart';

/// Fila de un movimiento lista para las pantallas de Inicio y Movimientos.
///
/// Decide el título y el subtítulo:
/// - Ahorro: título = meta; subtítulo = "Ahorro", nota y cuenta.
/// - Gasto/ingreso: título = categoría; si no hay, la nota; si tampoco, el
///   tipo. El subtítulo lleva la nota (si no se usó como título) y la cuenta.
class MovementRow extends StatelessWidget {
  const MovementRow({super.key, required this.movement});

  final MovementEntry movement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = movement.category;
    final note = movement.note;
    final isSaving = movement.type == MovementType.ahorro;

    final title = isSaving
        ? (movement.goalName ?? movement.type.label(l10n))
        : category?.displayName(l10n) ??
              (note != null && note.isNotEmpty
                  ? note
                  : movement.type.label(l10n));

    final subtitle = [
      // En un ahorro el título es la meta, así que el tipo se muestra en el
      // subtítulo para que quede claro que el dinero va a una meta.
      if (isSaving && movement.goalName != null) movement.type.label(l10n),
      if (note != null && note.isNotEmpty && note != title) note,
      movement.accountName ?? l10n.accountFallback,
    ].join(' · ');

    return MovementTile(
      title: title,
      subtitle: subtitle,
      amount: movement.signedAmount,
      icon: isSaving
          ? Icons.savings_outlined
          : category?.icon ??
                (movement.isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded),
      tone: isSaving
          ? CategoryTone.health
          : category?.tone ??
                (movement.isIncome ? CategoryTone.income : CategoryTone.other),
    );
  }
}
