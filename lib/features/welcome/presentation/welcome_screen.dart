// Archivo: lib/features/welcome/presentation/welcome_screen.dart
//
// Primera pantalla que ve un usuario sin sesión. Presenta la app y ofrece dos
// caminos: empezar el tutorial o ir directo al acceso.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo de la app.
                  Center(
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        size: 48,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 34,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Tres beneficios breves para explicar la propuesta.
                  _WelcomePoint(
                    icon: Icons.account_balance_wallet_outlined,
                    title: l10n.welcomePointAllTitle,
                    description: l10n.welcomePointAllDescription,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WelcomePoint(
                    icon: Icons.donut_large_rounded,
                    title: l10n.welcomePointSpendingTitle,
                    description: l10n.welcomePointSpendingDescription,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WelcomePoint(
                    icon: Icons.lock_outline_rounded,
                    title: l10n.welcomePointPrivateTitle,
                    description: l10n.welcomePointPrivateDescription,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FilledButton(
                    onPressed: () => context.push('/onboarding'),
                    child: Text(l10n.welcomeStart),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextButton(
                    onPressed: () => context.push('/entrar'),
                    child: Text(l10n.welcomeHaveAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila con icono, título y descripción usada en la bienvenida.
class _WelcomePoint extends StatelessWidget {
  const _WelcomePoint({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 22,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
