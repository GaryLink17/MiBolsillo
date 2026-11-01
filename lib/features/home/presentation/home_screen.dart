import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final now = DateTime.now();
    final monthLabel = '${_monthNames[now.month - 1]} ${now.year}';

    return AppPage(
      child: ListView(
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
            0,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 44),
            showDecimals: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Ingresos',
                  amount: 0,
                  icon: Icons.arrow_downward_rounded,
                  highlighted: true,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SummaryCard(
                  label: 'Gastos',
                  amount: 0,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Mis cuentas'),
          const SizedBox(height: AppSpacing.xs),
          _EmptySection(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Aún no tienes cuentas',
            message:
                'Agrega tu efectivo, tu cuenta de banco o tu tarjeta para '
                'empezar a ver tus saldos.',
            actionLabel: 'Agregar cuenta',
            onAction: () => context.go('/cuentas'),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Movimientos recientes'),
          const SizedBox(height: AppSpacing.xs),
          const _EmptySection(
            icon: Icons.receipt_long_outlined,
            title: 'Sin movimientos todavía',
            message:
                'Cuando registres un gasto, un ingreso o un ahorro, '
                'aparecerá aquí.',
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
          ),
        ],
      ),
    );
  }
}
