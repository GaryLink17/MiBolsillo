import 'package:intl/intl.dart';

/// Formato de moneda de la app: `RD$ 86,050.00`.
///
/// Usamos separador de miles con coma y decimales con punto, igual que las
/// capturas de diseño y que la costumbre en República Dominicana.
abstract final class MoneyFormat {
  static final NumberFormat _withoutDecimals = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _withDecimals = NumberFormat('#,##0.00', 'en_US');

  static String format(num amount, {bool decimals = false}) {
    return (decimals ? _withDecimals : _withoutDecimals).format(amount);
  }

  static String withSymbol(num amount, {bool decimals = true}) {
    final sign = amount < 0 ? '-' : '';
    return '${sign}RD\$ ${format(amount.abs(), decimals: decimals)}';
  }

  /// Convierte lo que el usuario escribe (`RD$ 1,250.50`) a un número.
  static double? tryParse(String input) {
    final cleaned = input
        .replaceAll(RegExp(r'[^0-9,.\-]'), '')
        .replaceAll(',', '');
    if (cleaned.isEmpty || cleaned == '-' || cleaned == '.') return null;
    return double.tryParse(cleaned);
  }
}
