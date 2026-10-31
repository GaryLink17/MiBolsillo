import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

/// Datos de muestra para validar el diseño mientras construimos la
/// persistencia real (Drift + Supabase). No forma parte de la app final.
class AccountPreview {
  const AccountPreview({
    required this.name,
    required this.subtitle,
    required this.balance,
    required this.icon,
  });

  final String name;
  final String subtitle;
  final double balance;
  final IconData icon;
}

class MovementPreview {
  const MovementPreview({
    required this.title,
    required this.category,
    required this.account,
    required this.amount,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String category;
  final String account;
  final double amount;
  final IconData icon;
  final CategoryTone tone;

  bool get isIncome => amount > 0;
}

abstract final class HomeDemo {
  static const accounts = [
    AccountPreview(
      name: 'Efectivo',
      subtitle: 'Dinero en mano',
      balance: 8300,
      icon: Icons.payments_outlined,
    ),
    AccountPreview(
      name: 'Cuenta corriente',
      subtitle: 'Cuenta bancaria',
      balance: 52450,
      icon: Icons.account_balance_outlined,
    ),
    AccountPreview(
      name: 'Ahorros',
      subtitle: 'Cuenta de ahorro',
      balance: 31500,
      icon: Icons.eco_outlined,
    ),
    AccountPreview(
      name: 'Tarjeta de crédito',
      subtitle: 'Crédito',
      balance: -6200,
      icon: Icons.credit_card_outlined,
    ),
  ];

  static const movements = [
    MovementPreview(
      title: 'Almuerzo con equipo',
      category: 'Comida',
      account: 'Cuenta corriente',
      amount: -1250,
      icon: Icons.restaurant,
      tone: CategoryTone.food,
    ),
    MovementPreview(
      title: 'Pago de cliente',
      category: 'Ingreso',
      account: 'Cuenta corriente',
      amount: 35000,
      icon: Icons.arrow_downward_rounded,
      tone: CategoryTone.income,
    ),
    MovementPreview(
      title: 'Taxi',
      category: 'Transporte',
      account: 'Efectivo',
      amount: -380,
      icon: Icons.directions_car_filled_outlined,
      tone: CategoryTone.transport,
    ),
    MovementPreview(
      title: 'Pago de internet',
      category: 'Hogar',
      account: 'Tarjeta de crédito',
      amount: -1800,
      icon: Icons.home_outlined,
      tone: CategoryTone.home,
    ),
  ];

  static const totalBalance = 86050.0;
  static const monthlyIncome = 62000.0;
  static const monthlyExpenses = 27430.0;
  static const monthLabel = 'Octubre 2026';
}
