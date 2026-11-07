// Archivo: lib/features/accounts/presentation/account_row.dart
//
// Fila reutilizable para mostrar una cuenta con su saldo. La usan Inicio y la
// pantalla "Cuentas y metas" para que ambas se vean exactamente igual.

import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../data/account.dart';

/// Tarjeta de una cuenta: icono del tipo, nombre y saldo actual.
class AccountRow extends StatelessWidget {
  const AccountRow({super.key, required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          CircleIcon(
            icon: account.kind.icon,
            size: 42,
            iconSize: 20,
            background: theme.colorScheme.primaryContainer,
            foreground: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              account.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          MoneyText(
            account.balance,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
            showDecimals: true,
          ),
        ],
      ),
    );
  }
}
