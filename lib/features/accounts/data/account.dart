// Archivo: lib/features/accounts/data/account.dart
//
// Modelos de cuentas y su tipo. Son objetos inmutables que la interfaz puede
// mostrar sin conocer los detalles de Supabase.

import 'package:flutter/material.dart';

/// Tipo de cuenta tal como lo guarda la base de datos (`account_kind`).
///
/// El nombre del enum coincide con el valor almacenado. Si la base trae un
/// valor desconocido se usa `otro` para no romper la pantalla.
enum AccountKind {
  efectivo(Icons.payments_outlined),
  banco(Icons.account_balance_outlined),
  ahorro(Icons.savings_outlined),
  tarjeta(Icons.credit_card_rounded),
  otro(Icons.account_balance_wallet_outlined);

  const AccountKind(this.icon);

  /// Icono asociado al tipo de cuenta.
  final IconData icon;

  static AccountKind fromDb(String? value) {
    return AccountKind.values.firstWhere(
      (kind) => kind.name == value,
      orElse: () => AccountKind.otro,
    );
  }
}

/// Cuenta con su saldo ya calculado por la vista `account_balances`.
///
/// La app nunca suma movimientos a mano para el saldo de una cuenta: la base
/// de datos lo hace en la vista, así la cifra siempre coincide con los
/// movimientos registrados.
@immutable
class AccountSummary {
  const AccountSummary({
    required this.id,
    required this.name,
    required this.kind,
    required this.balance,
  });

  final String id;
  final String name;
  final AccountKind kind;
  final double balance;
}

/// Cuenta que se crea al terminar el registro.
///
/// Solo se usa en el formulario de saldo inicial; después las cuentas se leen
/// como [AccountSummary].
@immutable
class InitialAccount {
  const InitialAccount({
    required this.name,
    required this.kind,
    required this.amount,
  });

  final String name;
  final AccountKind kind;
  final double amount;
}
