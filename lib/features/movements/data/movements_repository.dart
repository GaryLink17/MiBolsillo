import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'movement.dart';

/// Error de movimientos con un mensaje listo para mostrar al usuario.
class MovementsFailure implements Exception {
  const MovementsFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class MovementsRepository {
  MovementsRepository(this._client);

  final SupabaseClient _client;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Inserta un gasto o un ingreso del usuario con la sesión actual.
  Future<void> create(MovementDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const MovementsFailure('Tu sesión expiró. Vuelve a entrar.');
    }

    final note = draft.note?.trim();

    try {
      await _client.from('movements').insert({
        'user_id': userId,
        'type': draft.type.name,
        'amount': double.parse(draft.amount.toStringAsFixed(2)),
        'occurred_on': _dateFormat.format(draft.occurredOn),
        'account_id': draft.accountId,
        'category_id': draft.categoryId,
        'note': (note == null || note.isEmpty) ? null : note,
      });
    } on PostgrestException catch (error) {
      throw MovementsFailure(_translate(error));
    } catch (_) {
      throw const MovementsFailure(
        'No pudimos guardar el movimiento. Revisa tu conexión.',
      );
    }
  }

  /// Movimientos del usuario, del más reciente al más antiguo.
  ///
  /// El ahorro se incorpora en la entrega de metas.
  Future<List<MovementEntry>> list() async {
    try {
      final rows = await _client
          .from('movements')
          .select(
            'id, type, amount, occurred_on, note, '
            'accounts(name), '
            'categories(id, name, kind, tone, icon)',
          )
          .inFilter('type', const ['gasto', 'ingreso'])
          .order('occurred_on', ascending: false)
          .order('created_at', ascending: false);

      return rows.map(MovementEntry.fromMap).toList(growable: false);
    } on PostgrestException {
      throw const MovementsFailure(
        'No pudimos cargar tus movimientos. Revisa tu conexión.',
      );
    } catch (_) {
      throw const MovementsFailure(
        'No pudimos cargar tus movimientos. Revisa tu conexión.',
      );
    }
  }

  /// Ingresos y gastos del mes indicado.
  ///
  /// Se consulta aparte de la lista para que siga siendo exacto cuando la
  /// lista tenga filtros y paginación.
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
      throw const MovementsFailure(
        'No pudimos cargar los totales del mes. Revisa tu conexión.',
      );
    } catch (_) {
      throw const MovementsFailure(
        'No pudimos cargar los totales del mes. Revisa tu conexión.',
      );
    }
  }

  static String _translate(PostgrestException error) {
    return switch (error.code) {
      '42501' => 'Tu cuenta no tiene permisos para guardar movimientos.',
      '23503' => 'La cuenta o la categoría ya no existe.',
      '23514' => 'Revisa los datos del movimiento e intenta de nuevo.',
      _ => 'No pudimos guardar el movimiento. Intenta de nuevo.',
    };
  }
}
