import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/common.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppPageMetrics.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                AppCard(
                  onTap: () => _snack(
                    context,
                    'La cuenta y la sincronización llegan con Supabase.',
                  ),
                  child: Row(
                    children: [
                      CircleIcon(
                        icon: Icons.person_outline_rounded,
                        size: 56,
                        iconSize: 26,
                        background: theme.colorScheme.primaryContainer,
                        foreground: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu perfil',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Inicia sesión para sincronizar',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: palette.muted),
                    ],
                  ),
                ),
                _sectionLabel(context, 'General'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.dark_mode_outlined,
                                  size: 20,
                                  color: palette.muted,
                                ),
                                const SizedBox(width: AppSpacing.sm + 2),
                                Text(
                                  'Apariencia',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SegmentedSelector<ThemeMode>(
                              value: themeMode,
                              onChanged: (mode) => ref
                                  .read(themeModeProvider.notifier)
                                  .set(mode),
                              options: const [
                                SegmentedOption(
                                  value: ThemeMode.light,
                                  label: 'Claro',
                                ),
                                SegmentedOption(
                                  value: ThemeMode.dark,
                                  label: 'Oscuro',
                                ),
                                SegmentedOption(
                                  value: ThemeMode.system,
                                  label: 'Sistema',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.payments_outlined,
                        title: 'Moneda',
                        trailing: Text(
                          'RD\$ · Peso dominicano',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: palette.muted,
                          ),
                        ),
                        onTap: () => _snack(
                          context,
                          'Por ahora trabajamos solo con pesos dominicanos.',
                        ),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.grid_view_rounded,
                        title: 'Administrar categorías',
                        onTap: () => context.go('/categorias'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Recordatorios diarios',
                        trailing: const AppBadge(label: 'Pronto'),
                      ),
                    ],
                  ),
                ),
                _sectionLabel(context, 'Seguridad y datos'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Bloqueo con huella o rostro',
                        trailing: const AppBadge(label: 'Pronto'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.key_rounded,
                        title: 'Cambiar contraseña',
                        trailing: const AppBadge(label: 'Pronto'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.download_outlined,
                        title: 'Exportar mis datos',
                        trailing: const AppBadge(label: 'Pronto'),
                      ),
                    ],
                  ),
                ),
                _sectionLabel(context, 'Ayuda'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.school_outlined,
                        title: 'Ver tutorial de nuevo',
                        onTap: () => context.push('/onboarding', extra: true),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'Acerca de Mi Bolsillo',
                        onTap: () => _showAbout(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton.icon(
                  onPressed: () => _snack(
                    context,
                    'Disponible cuando actives tu cuenta en la nube.',
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Cerrar sesión'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Mi Bolsillo · versión 1.0.0',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, AppSpacing.xl, 4, AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: palette.muted, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mi Bolsillo'),
        content: const Text(
          'Versión 1.0.0\n\n'
          'Tus finanzas, claras y en orden. Hecho para acompañarte '
          'en cada gasto, ingreso y ahorro.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final trailingWidget =
        trailing ??
        (onTap != null
            ? Icon(Icons.chevron_right_rounded, color: palette.muted)
            : const AppBadge(label: 'Pronto'));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: palette.muted),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            const SizedBox(width: AppSpacing.xs),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}
