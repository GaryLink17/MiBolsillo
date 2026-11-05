// Archivo: lib/shared/widgets/common.dart
//
// Widgets pequeños y reutilizables que aparecen en varias pantallas:
// avatares de categoría, iconos circulares, badges, selector de mes y selector
// segmentado.
//
// Mantenerlos aquí evita duplicar estilos y garantiza que un cambio visual se
// aplique en toda la app.

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Icono dentro de un cuadrado redondeado con el color de un tono de categoría.
///
/// Se usa en las filas de movimientos y en las tarjetas de categoría. El radio
/// del cuadrado crece proporcionalmente al tamaño.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.icon,
    required this.tone,
    this.size = 48,
    this.iconSize = 22,
  });

  final IconData icon;
  final CategoryTone tone;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.palette.tone(tone);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(icon, size: iconSize, color: colors.foreground),
    );
  }
}

/// Icono dentro de un círculo. Los colores se pueden personalizar; por defecto
/// usa el fondo alterno de la paleta.
class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.icon,
    this.background,
    this.foreground,
    this.size = 40,
    this.iconSize = 20,
    this.borderColor,
  });

  final IconData icon;
  final Color? background;
  final Color? foreground;
  final double size;
  final double iconSize;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? context.palette.surfaceAlt,
        shape: BoxShape.circle,
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Icon(icon, size: iconSize, color: foreground ?? scheme.onSurface),
    );
  }
}

/// Botón circular con un icono y un tooltip opcional.
///
/// Se usa para acciones secundarias como volver, abrir Ajustes o cerrar.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.size = 46,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final button = Material(
      color: palette.surface,
      shape: CircleBorder(side: BorderSide(color: palette.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: 21,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
    // El tooltip se añade solo si existe para no envolver el botón sin motivo.
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Etiqueta pequeña tipo píldora. Sirve para contadores, estados y avisos
/// como "Pronto".
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.background,
    this.foreground,
  });

  final String label;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? palette.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground ?? palette.muted),
      ),
    );
  }
}

/// Selector de mes con forma de píldora.
///
/// Hoy muestra el mes actual; el `onTap` está preparado para abrir el
/// calendario en una entrega posterior.
class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: StadiumBorder(side: BorderSide(color: palette.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opción de un [SegmentedSelector].
class SegmentedOption<T> {
  const SegmentedOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Selector segmentado genérico (Gasto/Ingreso, Claro/Oscuro/Sistema, etc.).
///
/// La opción activa se resalta con animación y sombra en tema claro. Es
/// genérico para que el tipo de valor lo decida quien lo usa.
class SegmentedSelector<T> extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentedOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isLight = theme.brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: Semantics(
                selected: option.value == value,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(option.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: option.value == value
                          ? (isLight ? palette.surface : palette.background)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: option.value == value && isLight
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      option.label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: option.value == value
                            ? theme.colorScheme.onSurface
                            : palette.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
