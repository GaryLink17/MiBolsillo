import 'package:flutter/material.dart';

/// Tipo de cuenta tal como lo guarda la base de datos (`account_kind`).
enum AccountKind {
  efectivo('Efectivo', Icons.payments_outlined),
  banco('Banco', Icons.account_balance_outlined),
  ahorro('Ahorros', Icons.savings_outlined),
  tarjeta('Tarjeta', Icons.credit_card_rounded),
  otro('Otra cuenta', Icons.account_balance_wallet_outlined);

  const AccountKind(this.label, this.icon);

  final String label;
  final IconData icon;

  static AccountKind fromDb(String? value) {
    return AccountKind.values.firstWhere(
      (kind) => kind.name == value,
      orElse: () => AccountKind.otro,
    );
  }
}

/// Cuenta con su saldo ya calculado por la vista `account_balances`.
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
