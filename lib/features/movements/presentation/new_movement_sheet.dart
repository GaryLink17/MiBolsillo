import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/common.dart';

/// Primer paso visual del flujo de registro. El formulario real (monto,
/// cuenta, fecha, nota y categoría) llega en el hito de Movimientos.
Future<void> showNewMovementSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _NewMovementPreviewSheet(),
  );
}

class _NewMovementPreviewSheet extends StatefulWidget {
  const _NewMovementPreviewSheet();

  @override
  State<_NewMovementPreviewSheet> createState() =>
      _NewMovementPreviewSheetState();
}

class _NewMovementPreviewSheetState extends State<_NewMovementPreviewSheet> {
  int _selected = 0;

  static const _types = [
    (label: 'Gasto', icon: Icons.arrow_upward_rounded, tone: CategoryTone.food),
    (
      label: 'Ingreso',
      icon: Icons.arrow_downward_rounded,
      tone: CategoryTone.income,
    ),
    (label: 'Ahorro', icon: Icons.eco_outlined, tone: CategoryTone.health),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nuevo movimiento',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const AppBadge(label: 'Vista previa'),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '¿Qué quieres registrar?',
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (var index = 0; index < _types.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppCard(
                    onTap: () => setState(() => _selected = index),
                    color: _selected == index
                        ? theme.colorScheme.primaryContainer
                        : palette.surface,
                    borderColor: _selected == index
                        ? theme.colorScheme.primary
                        : palette.border,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        CircleIcon(
                          icon: _types[index].icon,
                          size: 40,
                          iconSize: 20,
                          background: palette
                              .tone(_types[index].tone)
                              .background,
                          foreground: palette
                              .tone(_types[index].tone)
                              .foreground,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _types[index].label,
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'El formulario completo se activa en el siguiente paso.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
        ],
      ),
    );
  }
}
