// Archivo: lib/core/formatting/money_format.dart
//
// Utilidades para mostrar y leer montos de dinero. Todo el formato de la app
// pasa por aquí para que los importes se vean siempre igual.

import 'package:intl/intl.dart';

/// Formato de moneda de la app: `RD$ 86,050.00`.
///
/// Usa coma para los miles y punto para los decimales, igual que la costumbre
/// en República Dominicana y que las capturas de diseño.
abstract final class MoneyFormat {
  // Se crean una sola vez porque `NumberFormat` es costoso de construir.
  static final NumberFormat _withoutDecimals = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _withDecimals = NumberFormat('#,##0.00', 'en_US');

  /// Devuelve el monto sin símbolo, por ejemplo `86,050` o `86,050.00`.
  static String format(num amount, {bool decimals = false}) {
    return (decimals ? _withDecimals : _withoutDecimals).format(amount);
  }

  /// Devuelve el monto con el símbolo `RD$`. Los negativos llevan el signo
  /// delante del símbolo: `-RD$ 6,200.00`.
  static String withSymbol(num amount, {bool decimals = true}) {
    final sign = amount < 0 ? '-' : '';
    return '${sign}RD\$ ${format(amount.abs(), decimals: decimals)}';
  }

  /// Convierte lo que el usuario escribe (`RD$ 1,250.50`) a un número.
  ///
  /// Elimina cualquier carácter que no sea dígito, coma, punto o signo, y las
  /// comas de miles. Devuelve `null` cuando no hay un número utilizable.
  static double? tryParse(String input) {
    final cleaned = input
        .replaceAll(RegExp(r'[^0-9,.\-]'), '')
        .replaceAll(',', '');
    if (cleaned.isEmpty || cleaned == '-' || cleaned == '.') return null;
    return double.tryParse(cleaned);
  }
}
