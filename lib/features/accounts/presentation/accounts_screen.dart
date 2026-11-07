// Archivo: lib/features/accounts/presentation/accounts_screen.dart
//
// Pantalla "Cuentas y metas". Reúne dos bloques independientes:
// 1. Las cuentas reales del usuario con su saldo actual.
// 2. Las metas de ahorro con su progreso, calculado por `goal_balances`.
//
// Cada bloque maneja sus propios estados de carga, error y vacío para que un
// fallo de una consulta no oculte el resto de la pantalla.
//
// El botón "Crear meta" abre el formulario en `/nueva-meta`.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/money_format.dart';
import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../goals/application/goals_providers.dart';
import '../../goals/data/goals_repository.dart';
import '../../goals/data/savings_goal.dart';
import '../../goals/presentation/goals_error_messages.dart';
import '../application/accounts_providers.dart';
import '../data/account.dart';
import '../data/accounts_repository.dart';
import 'account_row.dart';
import 'accounts_error_messages.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;

    // Mientras carga o falla se usa una lista vacía para no repetir null checks.
    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.value ?? const <AccountSummary>[];

    final goalsAsync = ref.watch(goalsProvider);
    final goals = goalsAsync.value ?? const <SavingsGoal>[];

    return AppPage(
      child: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          // Permite deslizar para recargar incluso cuando no hay contenido.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPageMetrics.pagePadding,
          children: [
            // Cabecera de la sección.
            Text(l10n.accountsTitle, style: theme.textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.accountsSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -----------------------------------------------------------------
            // Cuentas reales del usuario.
            // -----------------------------------------------------------------
            SectionHeader(title: l10n.homeMyAccounts),
            const SizedBox(height: AppSpacing.xs),
            if (accountsAsync.isLoading && accounts.isEmpty)
              const _LoadingCard()
            else if (accountsAsync.hasError && accounts.isEmpty)
              _ErrorCard(
                message: accountsAsync.error is AccountsFailure
                    ? (accountsAsync.error as AccountsFailure).error.message(
                        l10n,
                      )
                    : l10n.accountsLoadError,
                onRetry: () => ref.invalidate(accountsProvider),
              )
            else if (accounts.isEmpty)
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const CircleIcon(
                      icon: Icons.account_balance_wallet_outlined,
                      size: 48,
                      iconSize: 22,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.homeNoAccountsTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.homeNoAccountsMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      onPressed: () => context.push('/saldo-inicial'),
                      child: Text(l10n.homeConfigureInitialBalance),
                    ),
                  ],
                ),
              )
            else
              for (var i = 0; i < accounts.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.xs),
                AccountRow(account: accounts[i]),
              ],
            const SizedBox(height: AppSpacing.xxl),

            // -----------------------------------------------------------------
            // Metas de ahorro.
            // -----------------------------------------------------------------
            SectionHeader(
              title: l10n.goalsSectionTitle,
              actionLabel: l10n.goalsCreate,
              onAction: () => context.push('/nueva-meta'),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (goalsAsync.isLoading && goals.isEmpty)
              const _LoadingCard()
            else if (goalsAsync.hasError && goals.isEmpty)
              _ErrorCard(
                message: goalsAsync.error is GoalsFailure
                    ? (goalsAsync.error as GoalsFailure).error.message(l10n)
                    : l10n.goalsLoadError,
                onRetry: () => ref.invalidate(goalsProvider),
              )
            else if (goals.isEmpty)
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const CircleIcon(
                      icon: Icons.flag_outlined,
                      size: 48,
                      iconSize: 22,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.goalsEmptyTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.goalsEmptyMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      onPressed: () => context.push('/nueva-meta'),
                      child: Text(l10n.goalsCreate),
                    ),
                  ],
                ),
              )
            else
              for (var i = 0; i < goals.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                _GoalCard(goal: goals[i]),
              ],
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  /// Recarga cuentas y metas en paralelo.
  ///
  /// Se esperan ambas para que el indicador de refresco desaparezca solo cuando
  /// los datos estén listos.
  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(accountsProvider.future),
      ref.refresh(goalsProvider.future),
    ]);
  }
}

/// Tarjeta de una meta con su barra de progreso y lo que falta.
class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    // Las metas usan un tono verde fijo (salud/ahorro) para diferenciarse de
    // las cuentas, que usan el color principal del tema.
    final tone = palette.tone(CategoryTone.health);
    final complete = goal.isComplete;
    final accent = complete ? palette.income : tone.foreground;
    final accentBackground = complete
        ? palette.incomeBackground
        : tone.background;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleIcon(
                icon: complete ? Icons.check_rounded : Icons.flag_outlined,
                size: 42,
                iconSize: 20,
                background: accentBackground,
                foreground: accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  goal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (complete) ...[
                const SizedBox(width: AppSpacing.xs),
                AppBadge(
                  label: l10n.goalCompleted,
                  background: palette.incomeBackground,
                  foreground: palette.income,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 8,
              color: accent,
              backgroundColor: palette.surfaceAlt,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.goalSavedOf(
                    MoneyFormat.withSymbol(goal.saved),
                    MoneyFormat.withSymbol(goal.targetAmount),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${(goal.progress * 100).round()}%',
                style: theme.textTheme.labelLarge?.copyWith(color: accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Expanded(
                child: Text(
                  complete
                      ? l10n.goalCompleted
                      : l10n.goalRemaining(
                          MoneyFormat.withSymbol(goal.remaining),
                        ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: complete
                        ? palette.income
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (goal.targetDate != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.goalTargetFor(
                    MaterialLocalizations.of(context)
                        .formatMediumDate(goal.targetDate!),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Indicador de carga compacto para una sección.
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

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
class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

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
