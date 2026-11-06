// Archivo: lib/features/placeholder/presentation/placeholder_screens.dart
//
// Pantallas temporales de las secciones que todavía no tienen datos reales.
// Mantienen la navegación y el diseño mientras se implementan sus funciones.
//
// Cuando se implemente una sección (por ejemplo Cuentas y metas), se reemplaza
// su clase por la pantalla real y se elimina de aquí.

import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/empty_state.dart';

/// Pantalla temporal para las secciones que todavía no tienen datos reales.
/// Mantiene la navegación y el diseño ya probados.
class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                AppBadge(label: context.l10n.nextStep),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: EmptyState(
              icon: icon,
              title: context.l10n.placeholderTitle,
              message: message,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder de Cuentas. Se sustituirá por "Cuentas y metas" en la Parte 3.
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FeaturePlaceholderScreen(
      title: l10n.accountsTitle,
      icon: Icons.account_balance_wallet_outlined,
      message: l10n.accountsPlaceholder,
    );
  }
}

/// Placeholder de Categorías.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FeaturePlaceholderScreen(
      title: l10n.categoriesTitle,
      icon: Icons.pie_chart_outline_rounded,
      message: l10n.categoriesPlaceholder,
    );
  }
}
