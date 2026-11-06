// Archivo: lib/features/movements/presentation/movements_screen.dart
//
// Pantalla Movimientos: lista completa agrupada por día.
//
// Estados:
// - cargando (primera carga);
// - error con opción de reintentar;
// - vacío con acción para registrar el primero;
// - lista agrupada por "Hoy", "Ayer" y fechas anteriores.
//
// Deslizar hacia abajo recarga la lista.

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
import '../../../shared/widgets/empty_state.dart';
import '../application/movements_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';
import 'movement_row.dart';
import 'movements_error_messages.dart';

class MovementsScreen extends ConsumerWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final movementsAsync = ref.watch(movementsProvider);
    // Mientras carga o falla se usa una lista vacía para no repetir null checks.
    final movements = movementsAsync.value ?? const <MovementEntry>[];

    return AppPage(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(movementsProvider.future),
        child: ListView(
          // Permite deslizar para recargar incluso cuando la lista está vacía.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPageMetrics.pagePadding,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.movementsTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                // Contador visible cuando ya hay datos.
                if (movementsAsync.hasValue)
                  AppBadge(label: '${movements.length}'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Primera carga sin datos previos.
            if (movementsAsync.isLoading && movements.isEmpty)
              const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              )
            // Error sin datos previos.
            else if (movementsAsync.hasError && movements.isEmpty)
              _ErrorCard(
                message: movementsAsync.error is MovementsFailure
                    ? (movementsAsync.error as MovementsFailure).error.message(
                        l10n,
                      )
                    : l10n.movementsLoadError,
                onRetry: () => ref.invalidate(movementsProvider),
              )
            // Lista vacía.
            else if (movements.isEmpty)
              SizedBox(
                height: 380,
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.movementsEmptyTitle,
                  message: l10n.movementsEmptyMessage,
                  actionLabel: l10n.movementsRegisterFirst,
                  onAction: () => context.push('/nuevo-movimiento'),
                ),
              )
            // Lista con contenido, agrupada por día.
            else
              ..._groupedMovements(context, movements),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  /// Convierte la lista plana en secciones por día.
  ///
  /// El repositorio ya devuelve los movimientos del más reciente al más
  /// antiguo; aquí solo se agrupan y se ordenan los días por si acaso.
  List<Widget> _groupedMovements(
    BuildContext context,
    List<MovementEntry> movements,
  ) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final groups = <DateTime, List<MovementEntry>>{};

    for (final movement in movements) {
      // Se normaliza la fecha para que todos los movimientos del mismo día
      // caigan en la misma clave.
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
        // Encabezado del día: Hoy, Ayer o fecha.
        Text(
          _dayLabel(context, days[index]),
          style: theme.textTheme.titleSmall?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Tarjeta con las filas del día separadas por divisores.
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

  /// Texto del encabezado de un día.
  ///
  /// Se compara solo la fecha (sin hora) para que "hoy" sea correcto aunque
  /// hayan pasado algunas horas.
  String _dayLabel(BuildContext context, DateTime day) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final difference = todayDate.difference(day).inDays;

    if (difference == 0) return context.l10n.today;
    if (difference == 1) return context.l10n.yesterday;
    return MaterialLocalizations.of(context).formatMediumDate(day);
  }
}

/// Tarjeta de error con botón para volver a intentar.
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
