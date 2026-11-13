// Archivo: lib/core/formatting/money_cents.dart
//
// Conversión exacta entre decimales en texto y centavos para almacenamiento.
// No procesa textos de interfaz con símbolos ni separadores de miles.

/// Conversión de montos sin operaciones de punto flotante.
abstract final class MoneyCents {
  static final _decimal = RegExp(r'^(-?)([0-9]+)(?:\.([0-9]{1,2}))?$');
  static final _minimum = -(BigInt.one << 63);
  static final _maximum = (BigInt.one << 63) - BigInt.one;

  /// Convierte un decimal como `-25.50` a centavos dentro del rango de SQLite.
  ///
  /// Rechaza formatos ambiguos, más de dos decimales y valores fuera del rango
  /// de un entero con signo de 64 bits. No redondea ni acepta separadores.
  static int parseDecimal(String value) {
    final match = _decimal.firstMatch(value);
    if (match == null) throw FormatException('Monto decimal inválido', value);

    final whole = BigInt.parse(match[2]!);
    final fraction = (match[3] ?? '').padRight(2, '0');
    var cents = whole * BigInt.from(100) + BigInt.parse(fraction);
    if (match[1] == '-') cents = -cents;
    if (cents < _minimum || cents > _maximum) {
      throw FormatException('Monto fuera del rango de SQLite', value);
    }
    return cents.toInt();
  }

  /// Representa los centavos como decimal exacto, sin símbolo ni separadores.
  static String toDecimal(int cents) {
    final value = BigInt.from(cents);
    final absolute = value.abs();
    final whole = absolute ~/ BigInt.from(100);
    final fraction = (absolute % BigInt.from(100)).toString().padLeft(2, '0');
    return '${value.isNegative ? '-' : ''}$whole.$fraction';
  }
}
