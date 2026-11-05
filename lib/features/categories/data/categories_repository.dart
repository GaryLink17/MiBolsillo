import 'package:supabase_flutter/supabase_flutter.dart';

import 'category.dart';

/// Error de categorías con un mensaje listo para mostrar al usuario.
class CategoriesFailure implements Exception {
  const CategoriesFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class CategoriesRepository {
  CategoriesRepository(this._client);

  final SupabaseClient _client;

  /// Categorías activas del usuario, en el orden en que se crearon.
  Future<List<Category>> list() async {
    try {
      final rows = await _client
          .from('categories')
          .select('id, name, kind, tone, icon')
          .eq('is_archived', false)
          .order('created_at');

      return rows.map(Category.fromMap).toList(growable: false);
    } on PostgrestException {
      throw const CategoriesFailure(
        'No pudimos cargar tus categorías. Revisa tu conexión.',
      );
    } catch (_) {
      throw const CategoriesFailure(
        'No pudimos cargar tus categorías. Revisa tu conexión.',
      );
    }
  }
}
