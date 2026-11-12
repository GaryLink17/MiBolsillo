// Archivo: lib/features/movements/data/movements_repository.dart
//
// Acceso a los movimientos en Supabase: crear, listar y calcular totales del
// mes. Los fallos se devuelven como un [MovementsError] tipado.

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'movement.dart';

/// Motivos por los que una operación con movimientos puede fallar.
enum MovementsError {
  load,
  save,
  totals,
  permission,
  relatedMissing,
  invalidData,
  saveUnknown,
  sessionExpired,
}

/// Error de movimientos con el motivo tipado.
class MovementsFailure implements Exception {
  const MovementsFailure(this.error);

  final MovementsError error;

  @override
  String toString() => 'MovementsFailure(${error.name})';
}

class MovementsRepository {
  MovementsRepository(this._client);

  final SupabaseClient _client;

  // Supabase espera fechas como `yyyy-MM-dd` para columnas `date`.
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Inserta un gasto, un ingreso o un ahorro del usuario con la sesión actual.
  ///
  /// El monto se redondea a dos decimales antes de enviarlo y la nota se
  /// recorta; si queda vacía se guarda `null` para no ensuciar la base.
  ///
  /// El ahorro lleva `goal_id` y no lleva `category_id`; los otros tipos hacen
  /// lo contrario. Esto respeta la restricción `movement_destination`.
  Future<void> create(MovementDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const MovementsFailure(MovementsError.sessionExpired);
    }

    final note = draft.note?.trim();
    final isSaving = draft.type == MovementType.ahorro;

    try {
      await _client.from('movements').insert({
        'user_id': userId,
        'type': draft.type.name,
        'amount': double.parse(draft.amount.toStringAsFixed(2)),
        'occurred_on': _dateFormat.format(draft.occurredOn),
        'account_id': draft.accountId,
        'category_id': isSaving ? null : draft.categoryId,
        'goal_id': isSaving ? draft.goalId : null,
        'note': (note == null || note.isEmpty) ? null : note,
      });
    } on PostgrestException catch (error) {
      throw MovementsFailure(_translate(error));
    } catch (_) {
      throw const MovementsFailure(MovementsError.save);
    }
  }

  /// Movimientos del usuario, del más reciente al más antiguo.
  ///
  /// Se piden también el nombre de la cuenta y los datos de la categoría o de
  /// la meta para que la lista no tenga que hacer consultas adicionales por
  /// cada fila.
  Future<List<MovementEntry>> list() async {
    try {
      final rows = await _client
          .from('movements')
          .select(
            'id, type, amount, occurred_on, note, account_id, '
            'accounts(name), '
            'categories(id, name, kind, tone, icon), '
            'goals(name)',
          )
          .order('occurred_on', ascending: false)
          .order('created_at', ascending: false);

      return rows.map(MovementEntry.fromMap).toList(growable: false);
    } on PostgrestException {
      throw const MovementsFailure(MovementsError.load);
    } catch (_) {
      throw const MovementsFailure(MovementsError.load);
    }
  }

  /// Ingresos y gastos del mes indicado.
  ///
  /// Se consulta aparte de la lista para que siga siendo exacto cuando la
  /// lista tenga filtros y paginación. El rango es `[inicio, inicio del mes
  /// siguiente)`, así no hay que calcular el último día del mes.
  Future<MovementTotals> monthTotals(DateTime month) async {
    final start = DateTime(month.year, month.month);
    final nextMonth = DateTime(month.year, month.month + 1);

    try {
      final rows = await _client
          .from('movements')
          .select('type, amount')
          .inFilter('type', const ['gasto', 'ingreso'])
          .gte('occurred_on', _dateFormat.format(start))
          .lt('occurred_on', _dateFormat.format(nextMonth));

      // La suma se hace en el cliente porque son pocas filas mensuales y así
      // se evita una función RPC adicional en la base.
      var income = 0.0;
      var expenses = 0.0;
      for (final row in rows) {
        final amount = (row['amount'] as num).toDouble();
        if (row['type'] == 'ingreso') {
          income += amount;
        } else {
          expenses += amount;
        }
      }

      return MovementTotals(income: income, expenses: expenses);
    } on PostgrestException {
      throw const MovementsFailure(MovementsError.totals);
    } catch (_) {
      throw const MovementsFailure(MovementsError.totals);
    }
  }

  /// Traduce códigos de error de PostgreSQL a un [MovementsError].
  static MovementsError _translate(PostgrestException error) {
    return switch (error.code) {
      '42501' => MovementsError.permission,
      '23503' => MovementsError.relatedMissing,
      '23514' => MovementsError.invalidData,
      _ => MovementsError.saveUnknown,
    };
  }
}
