// Archivo: lib/features/home/presentation/home_screen.dart
//
// Pantalla de Inicio. Resume la situación financiera del usuario:
// - balance total (suma de los saldos de sus cuentas);
// - ingresos y gastos del mes actual;
// - lista de cuentas;
// - últimos cinco movimientos con acceso a "Ver todos".
//
// Cada bloque tiene sus propios estados de carga, error y vacío para que un
// fallo de una consulta no oculte el resto de la pantalla.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/data/account.dart';
import '../../accounts/data/accounts_repository.dart';
import '../../accounts/presentation/account_row.dart';
import '../../accounts/presentation/accounts_error_messages.dart';
import '../../goals/application/goals_providers.dart';
import '../../goals/data/savings_goal.dart';
import '../../movements/application/movements_providers.dart';
import '../../movements/data/movement.dart';
import '../../movements/data/movements_repository.dart';
import '../../movements/presentation/movement_row.dart';
import '../../movements/presentation/movements_error_messages.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final now = DateTime.now();
    // `MaterialLocalizations` usa el idioma activo: "noviembre de 2026" en
    // español y "November 2026" en inglés.
    final monthLabel = MaterialLocalizations.of(context).formatMonthYear(now);

    // Cuentas y balance total. Mientras carga se usa una lista vacía.
    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.value ?? const <AccountSummary>[];
    final accountsTotal = accounts.fold<double>(
      0,
      (sum, account) => sum + account.balance,
    );

    // Los ahorros salen de la cuenta pero siguen siendo dinero del usuario.
    // Se suman al balance para que el total no baje al apartar dinero en una
    // meta.
    final goalsAsync = ref.watch(goalsProvider);
    final savingsTotal = (goalsAsync.value ?? const <SavingsGoal>[])
        .fold<double>(0, (sum, goal) => sum + goal.saved);
    final total = accountsTotal + savingsTotal;

    // Movimientos recientes: solo los primeros cinco.
    final movementsAsync = ref.watch(movementsProvider);
    final recentMovements = (movementsAsync.value ?? const <MovementEntry>[])
        .take(5)
        .toList(growable: false);

    // Totales del mes actual, independientes de la lista.
    final totalsAsync = ref.watch(monthlyTotalsProvider);
    final totals = totalsAsync.value ?? MovementTotals.zero;

    return AppPage(
      child: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          // Permite el gesto de recarga aunque no haya suficiente contenido.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPageMetrics.pagePadding,
          children: [
            // Cabecera: mes y acceso a Ajustes.
            Row(
              children: [
                MonthSelector(
                  label: monthLabel,
                  onTap: () => _comingSoon(context, l10n.homeMonthSelector),
                ),
                const Spacer(),
                CircleIconButton(
                  icon: Icons.person_outline_rounded,
                  tooltip: l10n.settingsTooltip,
                  onTap: () => context.push('/ajustes'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Balance total.
            Text(
              l10n.homeBalanceTotal,
              style: theme.textTheme.bodyLarge?.copyWith(color: palette.muted),
            ),
            const SizedBox(height: AppSpacing.xxs),
            MoneyText(
              total,
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 44),
              showDecimals: true,
            ),
            // Si las metas fallan, el balance queda incompleto: se avisa sin
            // ocultar el resto de Inicio.
            if (goalsAsync.hasError) ...[
              const SizedBox(height: AppSpacing.xs),
              _InlineRetry(
                message: l10n.homeBalanceSavingsError,
                onRetry: () => ref.invalidate(goalsProvider),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Tarjetas de ingresos y gastos del mes.
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: l10n.homeIncome,
                    amount: totals.income,
                    icon: Icons.arrow_downward_rounded,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryCard(
                    label: l10n.homeExpenses,
                    amount: totals.expenses,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
            // Si los totales fallan, el resto de Inicio sigue visible.
            if (totalsAsync.hasError) ...[
              const SizedBox(height: AppSpacing.xs),
              _InlineRetry(
                message: l10n.homeTotalsError,
                onRetry: () => ref.invalidate(monthlyTotalsProvider),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),

            // Sección de cuentas.
            SectionHeader(title: l10n.homeMyAccounts),
            const SizedBox(height: AppSpacing.xs),
            if (accountsAsync.isLoading && accounts.isEmpty)
              const _LoadingSection()
            else if (accountsAsync.hasError && accounts.isEmpty)
              _ErrorSection(
                message: accountsAsync.error is AccountsFailure
                    ? (accountsAsync.error as AccountsFailure).error.message(
                        l10n,
                      )
                    : l10n.accountsLoadError,
                onRetry: () => ref.invalidate(accountsProvider),
              )
            else if (accounts.isEmpty)
              _EmptySection(
                icon: Icons.account_balance_wallet_outlined,
                title: l10n.homeNoAccountsTitle,
                message: l10n.homeNoAccountsMessage,
                actionLabel: l10n.homeConfigureInitialBalance,
                onAction: () => context.push('/saldo-inicial'),
              )
            else
              for (var i = 0; i < accounts.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.xs),
                AccountRow(account: accounts[i]),
              ],
            const SizedBox(height: AppSpacing.xxl),

            // Sección de movimientos recientes.
            SectionHeader(
              title: l10n.homeRecentMovements,
              actionLabel: recentMovements.isEmpty ? null : l10n.homeSeeAll,
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
                    ? (movementsAsync.error as MovementsFailure).error.message(
                        l10n,
                      )
                    : l10n.movementsLoadError,
                onRetry: () {
                  ref.invalidate(movementsProvider);
                  ref.invalidate(monthlyTotalsProvider);
                },
              )
            else if (recentMovements.isEmpty)
              _EmptySection(
                icon: Icons.receipt_long_outlined,
                title: l10n.homeNoMovementsTitle,
                message: l10n.homeNoMovementsMessage,
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

  /// Recarga las consultas del inicio en paralelo.
  ///
  /// Se esperan todas para que el indicador de refresco desaparezca solo
  /// cuando los datos estén listos.
  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(accountsProvider.future),
      ref.refresh(goalsProvider.future),
      ref.refresh(movementsProvider.future),
      ref.refresh(monthlyTotalsProvider.future),
    ]);
  }

  /// Aviso temporal para funciones que todavía no existen (selector de mes).
  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.homeComingSoon(feature))),
      );
  }
}

/// Indicador de carga compacto para una sección.
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

/// Error de una sección con botón para reintentar.
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
          TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}

/// Aviso compacto para errores que no bloquean toda la pantalla.
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
        TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
      ],
    );
  }
}

/// Estado vacío de una sección, dentro de una tarjeta.
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

/// Tarjeta de resumen para ingresos o gastos.
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
    // Ingresos se resaltan en verde; gastos usan el color normal del texto.
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
