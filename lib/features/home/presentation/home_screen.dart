import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../../../shared/widgets/movement_tile.dart';
import '../data/home_demo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return AppPage(
      child: ListView(
        padding: AppPageMetrics.pagePadding,
        children: [
          Row(
            children: [
              MonthSelector(
                label: HomeDemo.monthLabel,
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
            HomeDemo.totalBalance,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 44),
            showDecimals: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Ingresos',
                  amount: HomeDemo.monthlyIncome,
                  icon: Icons.arrow_downward_rounded,
                  highlighted: true,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryCard(
                  label: 'Gastos',
                  amount: HomeDemo.monthlyExpenses,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Mis cuentas',
            actionLabel: 'Ver todas',
            onAction: () => context.go('/cuentas'),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeDemo.accounts.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final account = HomeDemo.accounts[index];
                return AccountCard(
                  name: account.name,
                  balance: account.balance,
                  icon: account.icon,
                  onTap: () => context.go('/cuentas'),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SectionHeader(
            title: 'Movimientos recientes',
            actionLabel: 'Ver todo',
            onAction: () => context.go('/movimientos'),
          ),
          const SizedBox(height: AppSpacing.xxs),
          for (final movement in HomeDemo.movements)
            MovementTile(
              title: movement.title,
              category: movement.category,
              account: movement.account,
              amount: movement.amount,
              icon: movement.icon,
              tone: movement.tone,
            ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature llega en el próximo paso.')),
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
          ),
        ],
      ),
    );
  }
}
