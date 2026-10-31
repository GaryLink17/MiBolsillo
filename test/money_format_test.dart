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
      expect(MoneyFormat.withSymbol(-6200), '-RD\$ 6,200.00');
    });

    test('interpreta montos escritos por el usuario', () {
      expect(MoneyFormat.tryParse('RD\$ 1,250.50'), 1250.5);
      expect(MoneyFormat.tryParse(''), isNull);
      expect(MoneyFormat.tryParse('abc'), isNull);
    });
  });
}
