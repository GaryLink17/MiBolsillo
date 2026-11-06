// Archivo: lib/features/settings/presentation/settings_screen.dart
//
// Pantalla de Ajustes. Agrupa:
// - el perfil y el estado de la sesión;
// - preferencias generales (tema, moneda, categorías);
// - seguridad y datos (funciones futuras);
// - ayuda (repetir tutorial, acerca de);
// - cerrar o iniciar sesión.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/common.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/auth_error_messages.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final session = ref.watch(sessionProvider);

    // El nombre se guarda en `user_metadata` durante el registro.
    final fullName = session?.user.userMetadata?['full_name'] as String?;
    final hasSession = session != null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
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
                // Tarjeta de perfil. Sin sesión, invita a entrar.
                AppCard(
                  onTap: hasSession ? null : () => context.push('/entrar'),
                  child: Row(
                    children: [
                      CircleIcon(
                        icon: hasSession
                            ? Icons.verified_user_outlined
                            : Icons.person_outline_rounded,
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
                              hasSession
                                  ? (fullName?.isNotEmpty == true
                                        ? fullName!
                                        : l10n.settingsAccount)
                                  : l10n.settingsProfile,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasSession
                                  ? session.user.email ?? l10n.settingsActiveSession
                                  : l10n.settingsSignInToSync,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icono de nube si hay sesión; flecha si se puede entrar.
                      if (hasSession)
                        Icon(
                          Icons.cloud_done_outlined,
                          size: 20,
                          color: palette.income,
                        )
                      else
                        Icon(Icons.chevron_right_rounded, color: palette.muted),
                    ],
                  ),
                ),

                // Preferencias generales.
                _sectionLabel(context, l10n.settingsGeneral),
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
                                  l10n.settingsAppearance,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            // El cambio se guarda de inmediato en
                            // `shared_preferences` mediante el provider.
                            SegmentedSelector<ThemeMode>(
                              value: themeMode,
                              onChanged: (mode) => ref
                                  .read(themeModeProvider.notifier)
                                  .set(mode),
                              options: [
                                SegmentedOption(
                                  value: ThemeMode.light,
                                  label: l10n.themeLight,
                                ),
                                SegmentedOption(
                                  value: ThemeMode.dark,
                                  label: l10n.themeDark,
                                ),
                                SegmentedOption(
                                  value: ThemeMode.system,
                                  label: l10n.themeSystem,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.language_rounded,
                        title: l10n.settingsLanguage,
                        trailing: Text(
                          _languageLabel(l10n, language),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: palette.muted,
                          ),
                        ),
                        onTap: () => _showLanguagePicker(context, ref),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.payments_outlined,
                        title: l10n.settingsCurrency,
                        trailing: Text(
                          l10n.settingsCurrencyValue,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            color: palette.muted,
                          ),
                        ),
                        onTap: () => _snack(
                          context,
                          l10n.settingsCurrencyMessage,
                        ),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.grid_view_rounded,
                        title: l10n.settingsManageCategories,
                        onTap: () => context.go('/categorias'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: l10n.settingsDailyReminders,
                        trailing: AppBadge(label: l10n.soon),
                      ),
                    ],
                  ),
                ),

                // Seguridad y datos: pendientes por ahora.
                _sectionLabel(context, l10n.settingsSecurityData),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        title: l10n.settingsBiometric,
                        trailing: AppBadge(label: l10n.soon),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.key_rounded,
                        title: l10n.settingsChangePassword,
                        trailing: AppBadge(label: l10n.soon),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.download_outlined,
                        title: l10n.settingsExportData,
                        trailing: AppBadge(label: l10n.soon),
                      ),
                    ],
                  ),
                ),

                // Ayuda.
                _sectionLabel(context, l10n.settingsHelp),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.school_outlined,
                        title: l10n.settingsReplayTutorial,
                        // `extra: true` activa el modo replay del tutorial.
                        onTap: () => context.push('/onboarding', extra: true),
                      ),
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: l10n.settingsAbout,
                        onTap: () => _showAbout(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Acción de sesión según el estado.
                if (hasSession)
                  OutlinedButton.icon(
                    onPressed: () => _signOut(context, ref),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(l10n.settingsSignOut),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: () => context.push('/entrar'),
                    icon: const Icon(Icons.login_rounded, size: 20),
                    label: Text(l10n.settingsSignIn),
                  ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.settingsVersion,
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

  /// Encabezado de un grupo de ajustes.
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

  /// Cierra la sesión y avisa del resultado.
  ///
  /// El router reacciona al cambio de sesión y lleva al acceso.
  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(authRepositoryProvider);
    if (repository == null) return;
    try {
      await repository.signOut();
      if (!context.mounted) return;
      _snack(context, context.l10n.signOutSuccess);
    } on AuthFailure catch (failure) {
      if (!context.mounted) return;
      _snack(context, failure.error.message(context.l10n));
    }
  }

  /// Etiqueta del idioma activo en el selector de Ajustes.
  String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return switch (language) {
      AppLanguage.system => l10n.languageSystem,
      AppLanguage.spanish => l10n.languageSpanish,
      AppLanguage.english => l10n.languageEnglish,
    };
  }

  /// Abre un diálogo para elegir entre español, inglés o idioma del sistema.
  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final current = ref.read(languageProvider);

    final selected = await showDialog<AppLanguage>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsLanguage),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: RadioGroup<AppLanguage>(
          groupValue: current,
          onChanged: (value) => Navigator.of(dialogContext).pop(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppLanguage>(
                value: AppLanguage.spanish,
                title: Text(l10n.languageSpanish),
              ),
              RadioListTile<AppLanguage>(
                value: AppLanguage.english,
                title: Text(l10n.languageEnglish),
              ),
              RadioListTile<AppLanguage>(
                value: AppLanguage.system,
                title: Text(l10n.languageSystem),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );

    if (selected != null) {
      await ref.read(languageProvider.notifier).set(selected);
    }
  }

  /// Muestra un aviso temporal, reemplazando el anterior si lo hubiera.
  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Diálogo con la versión y una breve descripción de la app.
  void _showAbout(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.appTitle),
        content: Text(l10n.aboutContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

/// Fila de ajuste: icono, título, acción y elemento final opcional.
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
    // Si no se indica `trailing`, se usa una flecha cuando la fila es
    // pulsable o un badge "Pronto" cuando no lo es.
    final trailingWidget =
        trailing ??
        (onTap != null
            ? Icon(Icons.chevron_right_rounded, color: palette.muted)
            : AppBadge(label: context.l10n.soon));

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
