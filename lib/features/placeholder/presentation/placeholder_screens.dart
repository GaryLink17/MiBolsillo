import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
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
                const AppBadge(label: 'Próximo paso'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: EmptyState(
              icon: icon,
              title: 'Estamos construyendo esta sección',
              message: message,
            ),
          ),
        ],
      ),
    );
  }
}

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Movimientos',
      icon: Icons.receipt_long_outlined,
      message: 'Aquí podrás registrar y filtrar tus gastos, ingresos y ahorros por fecha, cuenta y categoría.',
    );
  }
}

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Cuentas',
      icon: Icons.account_balance_wallet_outlined,
      message:
          'Administra tus cuentas, saldos y metas de ahorro en un solo lugar.',
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderScreen(
      title: 'Categorías',
      icon: Icons.pie_chart_outline_rounded,
      message: 'Descubre en qué se va tu dinero con gráficos claros y comparaciones por semana, mes o año.',
    );
  }
}
