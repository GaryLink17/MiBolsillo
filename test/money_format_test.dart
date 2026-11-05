// Archivo: test/money_format_test.dart
//
// Pruebas del formato de dinero. No usan widgets ni red: solo comprueban que
// los montos se muestren y se lean como se espera en toda la app.

import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/core/formatting/money_format.dart';

void main() {
  group('MoneyFormat', () {
    test('formatea miles con coma y decimales con punto', () {
      expect(MoneyFormat.format(86050, decimals: true), '86,050.00');
      expect(MoneyFormat.format(86050), '86,050');
      expect(MoneyFormat.withSymbol(27430), 'RD\$ 27,430.00');
      expect(MoneyFormat.withSymbol(0), 'RD\$ 0.00');
    });

    test('conserva el signo negativo', () {
      // El signo va delante del símbolo: -RD$ 6,200.00
      expect(MoneyFormat.withSymbol(-6200), '-RD\$ 6,200.00');
    });

    test('interpreta montos escritos por el usuario', () {
      // Se aceptan símbolo, espacios y comas de miles.
      expect(MoneyFormat.tryParse('RD\$ 1,250.50'), 1250.5);
      expect(MoneyFormat.tryParse(''), isNull);
      expect(MoneyFormat.tryParse('abc'), isNull);
    });
  });
}
