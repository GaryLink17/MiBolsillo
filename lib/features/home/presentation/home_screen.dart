import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/data/account.dart';
import '../../accounts/data/accounts_repository.dart';
import '../../movements/application/movements_providers.dart';
import '../../movements/data/movement.dart';
import '../../movements/data/movements_repository.dart';
import '../../movements/presentation/movement_row.dart';

const _monthNames = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final now = DateTime.now();
    final monthLabel = '${_monthNames[now.month - 1]} ${now.year}';

    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.value ?? const <AccountSummary>[];
    final total = accounts.fold<double>(
      0,
      (sum, account) => sum + account.balance,
    );

    final movementsAsync = ref.watch(movementsProvider);
    final recentMovements = (movementsAsync.value ?? const <MovementEntry>[])
        .take(5)
        .toList(growable: false);
    final totalsAsync = ref.watch(monthlyTotalsProvider);
    final totals = totalsAsync.value ?? MovementTotals.zero;

    return AppPage(
      child: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPageMetrics.pagePadding,
          children: [
            Row(
              children: [
                MonthSelector(
                  label: monthLabel,
                  onTap: () => _comingSoon(context, 'El selector de mes'),
                ),
                const Spacer(),
                CircleIconButton(
                  icon: Icons.person_outline_rounded,
                  tooltip: 'Ajustes',
                  onTap: () => context.push('/ajustes'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Balance total',
              style: theme.textTheme.bodyLarge?.copyWith(color: palette.muted),
            ),
            const SizedBox(height: AppSpacing.xxs),
            MoneyText(
              total,
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 44),
              showDecimals: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Ingresos',
                    amount: totals.income,
                    icon: Icons.arrow_downward_rounded,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryCard(
                    label: 'Gastos',
                    amount: totals.expenses,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
            if (totalsAsync.hasError) ...[
              const SizedBox(height: AppSpacing.xs),
              _InlineRetry(
                message: 'No pudimos cargar los totales del mes.',
                onRetry: () => ref.invalidate(monthlyTotalsProvider),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Mis cuentas'),
            const SizedBox(height: AppSpacing.xs),
            if (accountsAsync.isLoading && accounts.isEmpty)
              const _LoadingSection()
            else if (accountsAsync.hasError && accounts.isEmpty)
              _ErrorSection(
                message: accountsAsync.error is AccountsFailure
                    ? (accountsAsync.error as AccountsFailure).message
                    : 'No pudimos cargar tus cuentas. Revisa tu conexión.',
                onRetry: () => ref.invalidate(accountsProvider),
              )
            else if (accounts.isEmpty)
              _EmptySection(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Aún no tienes cuentas',
                message:
                    'Configura tu saldo inicial para ver cuánto dinero '
                    'tienes hoy en cada cuenta.',
                actionLabel: 'Configurar saldo inicial',
                onAction: () => context.push('/saldo-inicial'),
              )
            else
              for (var i = 0; i < accounts.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.xs),
                _AccountRow(account: accounts[i]),
              ],
            const SizedBox(height: AppSpacing.xxl),
            SectionHeader(
              title: 'Movimientos recientes',
              actionLabel: recentMovements.isEmpty ? null : 'Ver todos',
              onAction: recentMovements.isEmpty
                  ? null
                  : () => context.go('/movimientos'),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (movementsAsync.isLoading && recentMovements.isEmpty)
              const _LoadingSection()
            else if (movementsAsync.hasError && recentMovements.isEmpty)
              _ErrorSection(
                message: movementsAsync.error is MovementsFailure
                    ? (movementsAsync.error as MovementsFailure).message
                    : 'No pudimos cargar tus movimientos. Revisa tu conexión.',
                onRetry: () {
                  ref.invalidate(movementsProvider);
                  ref.invalidate(monthlyTotalsProvider);
                },
              )
            else if (recentMovements.isEmpty)
              const _EmptySection(
                icon: Icons.receipt_long_outlined,
                title: 'Sin movimientos todavía',
                message:
                    'Cuando registres un gasto o un ingreso, '
                    'aparecerá aquí.',
              )
            else
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < recentMovements.length;
                      index++
                    ) ...[
                      if (index > 0) Divider(height: 1, color: palette.border),
                      MovementRow(movement: recentMovements[index]),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(accountsProvider.future),
      ref.refresh(movementsProvider.future),
      ref.refresh(monthlyTotalsProvider.future),
    ]);
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature llega en el próximo paso.')),
      );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.account});

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

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 26, color: palette.muted),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: AppSpacing.xxs),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

class _InlineRetry extends StatelessWidget {
  const _InlineRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Row(
      children: [
        Icon(Icons.cloud_off_rounded, size: 16, color: palette.muted),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          CircleIcon(icon: icon, size: 48, iconSize: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    this.highlighted = false,
  });

  final String label;
  final double amount;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final foreground = highlighted
        ? palette.income
        : theme.colorScheme.onSurface;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: highlighted
                      ? palette.incomeBackground
                      : palette.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: foreground),
              ),
              const SizedBox(width: AppSpacing.xs + 2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          MoneyText(
            amount,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
            showDecimals: true,
          ),
        ],
      ),
    );
  }
}
