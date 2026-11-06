// Archivo: lib/features/categories/data/categories_repository.dart
//
// Lectura de categorías desde Supabase. Las categorías son del usuario y
// están protegidas por RLS. Los fallos se devuelven como [CategoriesError].

import 'package:supabase_flutter/supabase_flutter.dart';

import 'category.dart';

/// Motivos por los que una operación con categorías puede fallar.
enum CategoriesError { load }

/// Error de categorías con el motivo tipado.
class CategoriesFailure implements Exception {
  const CategoriesFailure(this.error);

  final CategoriesError error;

  @override
  String toString() => 'CategoriesFailure(${error.name})';
}

class CategoriesRepository {
  CategoriesRepository(this._client);

  final SupabaseClient _client;

  /// Categorías activas del usuario, en el orden en que se crearon.
  ///
  /// Al filtrar `is_archived = false` se ocultan las que el usuario ya no usa,
  /// pero se conservan en la base para no romper movimientos antiguos.
  Future<List<Category>> list() async {
    try {
      final rows = await _client
          .from('categories')
          .select('id, name, kind, tone, icon')
          .eq('is_archived', false)
          .order('created_at');

      return rows.map(Category.fromMap).toList(growable: false);
    } on PostgrestException {
      throw const CategoriesFailure(CategoriesError.load);
    } catch (_) {
      throw const CategoriesFailure(CategoriesError.load);
    }
  }
}
