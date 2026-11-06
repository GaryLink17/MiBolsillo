// Archivo: lib/shared/widgets/app_bottom_nav.dart
//
// Barra de navegación inferior con cuatro pestañas y un botón central para
// registrar un movimiento.
//
// El botón "+" ocupa el centro visual de la barra, pero no es una pestaña: abre
// el formulario como una pantalla nueva.

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/l10n/l10n.dart';
import '../../l10n/generated/app_localizations.dart';

/// Datos de una pestaña de la barra inferior.
class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Pestañas en el mismo orden que las ramas del `StatefulShellRoute`.
///
/// Es una función porque las etiquetas dependen del idioma activo.
List<_NavItem> _items(AppLocalizations l10n) => [
  _NavItem(
    label: l10n.navHome,
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  ),
  _NavItem(
    label: l10n.navMovements,
    icon: Icons.format_list_bulleted_rounded,
    activeIcon: Icons.format_list_bulleted_rounded,
  ),
  _NavItem(
    label: l10n.navAccounts,
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet_rounded,
  ),
  _NavItem(
    label: l10n.navCategories,
    icon: Icons.pie_chart_outline_rounded,
    activeIcon: Icons.pie_chart_rounded,
  ),
];

/// Barra inferior de la app.
///
/// Recibe el índice activo y dos callbacks: cambiar de pestaña y abrir el
/// formulario de nuevo movimiento.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onAddPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _items(l10n);
    final theme = Theme.of(context);
    final palette = context.palette;
    final scheme = theme.colorScheme;

    /// Construye una pestaña normal (icono + texto).
    Widget destination(int index) {
      final item = items[index];
      final selected = currentIndex == index;
      final color = selected ? scheme.primary : palette.muted;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          label: item.label,
          child: InkResponse(
            onTap: () => onDestinationSelected(index),
            radius: 40,
            containedInkWell: false,
            highlightShape: BoxShape.rectangle,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 23,
                  color: color,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              destination(0),
              destination(1),
              // Botón central elevado. Se desplaza hacia arriba para que
              // sobresalga del borde de la barra.
              Expanded(
                child: Semantics(
                  button: true,
                  label: l10n.navNewMovement,
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: Center(
                      child: GestureDetector(
                        onTap: onAddPressed,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 30,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              destination(2),
              destination(3),
            ],
          ),
        ),
      ),
    );
  }
}
