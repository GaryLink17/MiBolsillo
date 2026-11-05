import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/empty_state.dart';
import '../application/movements_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';
import 'movement_row.dart';

class MovementsScreen extends ConsumerWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final movementsAsync = ref.watch(movementsProvider);
    final movements = movementsAsync.value ?? const <MovementEntry>[];

    return AppPage(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(movementsProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPageMetrics.pagePadding,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Movimientos',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                if (movementsAsync.hasValue)
                  AppBadge(label: '${movements.length}'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            if (movementsAsync.isLoading && movements.isEmpty)
              const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (movementsAsync.hasError && movements.isEmpty)
              _ErrorCard(
                message: movementsAsync.error is MovementsFailure
                    ? (movementsAsync.error as MovementsFailure).message
                    : 'No pudimos cargar tus movimientos. Revisa tu conexión.',
                onRetry: () => ref.invalidate(movementsProvider),
              )
            else if (movements.isEmpty)
              SizedBox(
                height: 380,
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Sin movimientos todavía',
                  message:
                      'Registra tu primer gasto o ingreso para empezar a '
                      'ver cómo se mueve tu dinero.',
                  actionLabel: 'Registrar el primero',
                  onAction: () => context.push('/nuevo-movimiento'),
                ),
              )
            else
              ..._groupedMovements(context, movements),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  List<Widget> _groupedMovements(
    BuildContext context,
    List<MovementEntry> movements,
  ) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final groups = <DateTime, List<MovementEntry>>{};

    for (final movement in movements) {
      final day = DateTime(
        movement.occurredOn.year,
        movement.occurredOn.month,
        movement.occurredOn.day,
      );
      groups.putIfAbsent(day, () => []).add(movement);
    }

    final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return [
      for (var index = 0; index < days.length; index++) ...[
        if (index > 0) const SizedBox(height: AppSpacing.lg),
        Text(
          _dayLabel(context, days[index]),
          style: theme.textTheme.titleSmall?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            children: [
              for (
                var movementIndex = 0;
                movementIndex < groups[days[index]]!.length;
                movementIndex++
              ) ...[
                if (movementIndex > 0)
                  Divider(height: 1, color: palette.border),
                MovementRow(movement: groups[days[index]]![movementIndex]),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  String _dayLabel(BuildContext context, DateTime day) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final difference = todayDate.difference(day).inDays;

    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Ayer';
    return MaterialLocalizations.of(context).formatMediumDate(day);
  }
}

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
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
