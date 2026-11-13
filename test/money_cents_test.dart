// Archivo: test/money_cents_test.dart
//
// Pruebas de conversión exacta de montos para almacenamiento en centavos.

import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/core/formatting/money_cents.dart';

void main() {
  test('convierte decimales exactos a centavos', () {
    expect(MoneyCents.parseDecimal('1'), 100);
    expect(MoneyCents.parseDecimal('1.2'), 120);
    expect(MoneyCents.parseDecimal('86050.75'), 8605075);
    expect(MoneyCents.parseDecimal('-25.50'), -2550);
    expect(MoneyCents.parseDecimal('-0.01'), -1);
    expect(MoneyCents.parseDecimal('0.00'), 0);
  });

  test('convierte centavos a un decimal exacto', () {
    expect(MoneyCents.toDecimal(100), '1.00');
    expect(MoneyCents.toDecimal(8605075), '86050.75');
    expect(MoneyCents.toDecimal(-2550), '-25.50');
    expect(MoneyCents.toDecimal(-1), '-0.01');
    expect(MoneyCents.toDecimal(0), '0.00');
  });

  test('respeta los límites enteros de SQLite', () {
    const maximum = '92233720368547758.07';
    const minimum = '-92233720368547758.08';
    expect(MoneyCents.toDecimal(MoneyCents.parseDecimal(maximum)), maximum);
    expect(MoneyCents.toDecimal(MoneyCents.parseDecimal(minimum)), minimum);
    expect(
      () => MoneyCents.parseDecimal('92233720368547758.08'),
      throwsFormatException,
    );
    expect(
      () => MoneyCents.parseDecimal('-92233720368547758.09'),
      throwsFormatException,
    );
  });

  test('rechaza formatos ambiguos o más de dos decimales', () {
    for (final value in [
      '',
      '.',
      '1.',
      '.50',
      '1.234',
      '1,000.00',
      'RD\$ 1.00',
      ' 1.00',
      '+1',
      '--1',
      '1e2',
      'NaN',
    ]) {
      expect(
        () => MoneyCents.parseDecimal(value),
        throwsFormatException,
        reason: value,
      );
    }
  });
}
