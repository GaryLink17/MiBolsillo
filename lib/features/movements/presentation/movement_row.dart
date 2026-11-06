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
/// - título: nombre de la categoría; si no hay, la nota; si tampoco, el tipo.
/// - subtítulo: nota (si no se usó como título) y nombre de la cuenta.
class MovementRow extends StatelessWidget {
  const MovementRow({super.key, required this.movement});

  final MovementEntry movement;

  @override
  Widget build(BuildContext context) {
    final category = movement.category;
    final note = movement.note;
    final title =
        category?.displayName(context.l10n) ??
        (note != null && note.isNotEmpty
            ? note
            : movement.type.label(context.l10n));
    final subtitle = [
      if (note != null && note.isNotEmpty && note != title) note,
      movement.accountName ?? context.l10n.accountFallback,
    ].join(' · ');

    return MovementTile(
      title: title,
      subtitle: subtitle,
      amount: movement.signedAmount,
      icon:
          category?.icon ??
          (movement.isIncome
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded),
      tone:
          category?.tone ??
          (movement.isIncome ? CategoryTone.income : CategoryTone.other),
    );
  }
}
