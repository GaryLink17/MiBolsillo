// Archivo: lib/features/goals/data/goals_repository.dart
//
// Acceso a las metas de ahorro en Supabase. La lectura usa la vista
// `goal_balances`, que ya calcula cuánto se ha ahorrado en cada meta a partir
// de los movimientos de tipo `ahorro`.
//
// Los fallos se devuelven como un [GoalsError] tipado para que la interfaz los
// traduzca al idioma activo sin depender de los mensajes de PostgreSQL.

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'savings_goal.dart';

/// Motivos por los que una operación con metas puede fallar.
enum GoalsError {
  load,
  save,
  permission,
  invalidData,
  saveUnknown,
  sessionExpired,
}

/// Error de metas con el motivo tipado.
class GoalsFailure implements Exception {
  const GoalsFailure(this.error);

  final GoalsError error;

  @override
  String toString() => 'GoalsFailure(${error.name})';
}

class GoalsRepository {
  GoalsRepository(this._client);

  final SupabaseClient _client;

  // Supabase espera fechas como `yyyy-MM-dd` para columnas `date`.
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Metas activas del usuario con su progreso.
  ///
  /// `goal_balances` no expone `created_at`, así que se ordena por nombre para
  /// que la lista sea estable entre recargas. Se ocultan las metas archivadas.
  Future<List<SavingsGoal>> list() async {
    try {
      final rows = await _client
          .from('goal_balances')
          .select('id, name, target_amount, target_date, saved')
          .eq('is_archived', false)
          .order('name');

      return rows.map(SavingsGoal.fromMap).toList(growable: false);
    } on PostgrestException {
      throw const GoalsFailure(GoalsError.load);
    } catch (_) {
      throw const GoalsFailure(GoalsError.load);
    }
  }

  /// Inserta una meta nueva para el usuario con la sesión actual.
  ///
  /// El monto se redondea a dos decimales y el nombre se recorta para respetar
  /// el límite de la base (1–60 caracteres). Si no hay fecha objetivo se
  /// guarda `null`.
  Future<void> create(GoalDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const GoalsFailure(GoalsError.sessionExpired);
    }

    try {
      await _client.from('goals').insert({
        'user_id': userId,
        'name': draft.name.trim(),
        'target_amount': double.parse(draft.targetAmount.toStringAsFixed(2)),
        'target_date': draft.targetDate == null
            ? null
            : _dateFormat.format(draft.targetDate!),
      });
    } on PostgrestException catch (error) {
      throw GoalsFailure(_translate(error));
    } catch (_) {
      throw const GoalsFailure(GoalsError.save);
    }
  }

  /// Traduce códigos de error de PostgreSQL a un [GoalsError].
  ///
  /// 42501: la política RLS rechazó la operación.
  /// 23514 / 23502: incumple una restricción de la tabla.
  static GoalsError _translate(PostgrestException error) {
    return switch (error.code) {
      '42501' => GoalsError.permission,
      '23514' || '23502' => GoalsError.invalidData,
      _ => GoalsError.saveUnknown,
    };
  }
}
