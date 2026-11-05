// Archivo: lib/shared/widgets/app_card.dart
//
// Tarjeta y encabezado de sección reutilizables. Son la base visual de Inicio,
// Movimientos, Cuentas y Ajustes.

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Tarjeta con fondo, borde y esquinas redondeadas.
///
/// Si se pasa `onTap`, se envuelve el contenido en `Material` + `InkWell` para
/// que tenga efecto de pulsación. Si no, se evita `Material` innecesario.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = AppRadius.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? palette.border),
      ),
      child: content,
    );
  }
}

/// Título de sección con una acción opcional a la derecha (por ejemplo,
/// "Ver todos").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
