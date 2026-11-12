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
import '../../categories/presentation/category_labels.dart';
import '../application/movements_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';
import 'movement_labels.dart';
import 'movement_row.dart';
import 'movements_error_messages.dart';

class MovementsScreen extends ConsumerStatefulWidget {
  const MovementsScreen({super.key});

  @override
  ConsumerState<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends ConsumerState<MovementsScreen> {
  final _search = TextEditingController();
  MovementType? _type;
  String? _accountId;
  String? _categoryId;
  DateTimeRange? _dates;
  bool _filtersExpanded = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _hasFilters =>
      _search.text.trim().isNotEmpty ||
      _type != null ||
      _accountId != null ||
      _categoryId != null ||
      _dates != null;

  int get _activeFilterCount => [
    _type != null,
    _accountId != null,
    _categoryId != null,
    _dates != null,
  ].where((active) => active).length;

  void _clearFilters() => setState(() {
    _search.clear();
    _type = null;
    _accountId = null;
    _categoryId = null;
    _dates = null;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final movementsAsync = ref.watch(movementsProvider);
    // Mientras carga o falla se usa una lista vacía para no repetir null checks.
    final movements = movementsAsync.value ?? const <MovementEntry>[];
    final query = _search.text.trim().toLowerCase();
    final accounts = <String, String>{};
    final categories = <String, String>{};
    for (final movement in movements) {
      if (movement.accountId != null && movement.accountName != null) {
        accounts[movement.accountId!] = movement.accountName!;
      }
      final category = movement.category;
      if (category != null) {
        categories[category.id] = category.displayName(l10n);
      }
    }
    final filtered = movements
        .where((movement) {
          final date = DateUtils.dateOnly(movement.occurredOn);
          return (_type == null || movement.type == _type) &&
              (_accountId == null || movement.accountId == _accountId) &&
              (_categoryId == null || movement.category?.id == _categoryId) &&
              (_dates == null ||
                  (!date.isBefore(_dates!.start) &&
                      !date.isAfter(_dates!.end))) &&
              (query.isEmpty ||
                  [
                    movement.note,
                    movement.accountName,
                    movement.category?.displayName(l10n),
                    movement.goalName,
                  ].any(
                    (value) => value?.toLowerCase().contains(query) ?? false,
                  ));
        })
        .toList(growable: false);

    return Material(
      color: Colors.transparent,
      child: AppPage(
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
                    AppBadge(label: '${filtered.length}'),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              if (movements.isNotEmpty) ...[
                TextField(
                  key: const ValueKey('movements-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.movementsSearch,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    onExpansionChanged: (expanded) =>
                        setState(() => _filtersExpanded = expanded),
                    shape: const Border(),
                    collapsedShape: const Border(),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    leading: Icon(
                      Icons.tune_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Row(
                      children: [
                        Flexible(child: Text(l10n.movementsFilters)),
                        if (_activeFilterCount > 0) ...[
                          const SizedBox(width: AppSpacing.xs),
                          AppBadge(label: '$_activeFilterCount'),
                        ],
                      ],
                    ),
                    children: [
                      DropdownButtonFormField<MovementType>(
                        key: ValueKey('type-$_type'),
                        initialValue: _type,
                        decoration: InputDecoration(
                          labelText: l10n.movementsFilterType,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.movementsFilterAll),
                          ),
                          for (final type in MovementType.values)
                            DropdownMenuItem(
                              value: type,
                              child: Text(type.label(l10n)),
                            ),
                        ],
                        onChanged: (value) => setState(() => _type = value),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'account-$_accountId-${accounts.containsKey(_accountId)}',
                        ),
                        initialValue: accounts.containsKey(_accountId)
                            ? _accountId
                            : null,
                        decoration: InputDecoration(
                          labelText: l10n.movementsFilterAccount,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.movementsFilterAll),
                          ),
                          for (final entry in accounts.entries)
                            DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _accountId = value),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'category-$_categoryId-${categories.containsKey(_categoryId)}',
                        ),
                        initialValue: categories.containsKey(_categoryId)
                            ? _categoryId
                            : null,
                        decoration: InputDecoration(
                          labelText: l10n.movementsFilterCategory,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.movementsFilterAll),
                          ),
                          for (final entry in categories.entries)
                            DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextButton.icon(
                        onPressed: () async {
                          final range = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100, 12, 31),
                            initialDateRange: _dates,
                          );
                          if (range != null && mounted) {
                            setState(() => _dates = range);
                          }
                        },
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _dates == null
                              ? l10n.movementsFilterDate
                              : '${MaterialLocalizations.of(context).formatShortDate(_dates!.start)} – ${MaterialLocalizations.of(context).formatShortDate(_dates!.end)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_hasFilters)
                        TextButton(
                          onPressed: _clearFilters,
                          child: Text(l10n.movementsClearFilters),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

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
                      ? (movementsAsync.error as MovementsFailure).error
                            .message(l10n)
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
              else if (filtered.isEmpty)
                EmptyState(
                  icon: Icons.search_off,
                  title: l10n.movementsNoResults,
                  message: l10n.movementsNoResultsMessage,
                  actionLabel: _filtersExpanded
                      ? null
                      : l10n.movementsClearFilters,
                  onAction: _filtersExpanded ? null : _clearFilters,
                )
              else
                ..._groupedMovements(context, filtered),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
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
