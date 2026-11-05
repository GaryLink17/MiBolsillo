import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

/// Tipo de categoría tal como lo guarda la base (`category_kind`).
enum CategoryKind {
  gasto('Gasto'),
  ingreso('Ingreso');

  const CategoryKind(this.label);

  final String label;

  static CategoryKind fromDb(String? value) {
    return value == 'ingreso' ? CategoryKind.ingreso : CategoryKind.gasto;
  }
}

@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.kind,
    required this.tone,
    required this.icon,
  });

  final String id;
  final String name;
  final CategoryKind kind;
  final CategoryTone tone;
  final IconData icon;

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      kind: CategoryKind.fromDb(map['kind'] as String?),
      tone: _toneFromDb(map['tone'] as String?),
      icon: _iconFromDb(map['icon'] as String?),
    );
  }

  static CategoryTone _toneFromDb(String? value) {
    return CategoryTone.values.firstWhere(
      (tone) => tone.name == value,
      orElse: () => CategoryTone.other,
    );
  }

  static IconData _iconFromDb(String? value) {
    return switch (value) {
      'restaurant' => Icons.restaurant_rounded,
      'directions_car' => Icons.directions_car_rounded,
      'home' => Icons.home_rounded,
      'celebration' => Icons.celebration_rounded,
      'health_and_safety' => Icons.health_and_safety_rounded,
      'payments' => Icons.payments_rounded,
      _ => Icons.category_rounded,
    };
  }
}
