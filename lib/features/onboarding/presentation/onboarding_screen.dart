// Archivo: lib/features/onboarding/presentation/onboarding_screen.dart
//
// Tutorial inicial de cuatro pasos. Se muestra una sola vez (la preferencia
// `onboarding_completed` lo controla), pero también se puede volver a ver
// desde Ajustes con `replay: true`.
//
// Al terminar:
// - si se abrió en modo replay, se cierra la pantalla;
// - si no hay sesión, se va al acceso;
// - si hay sesión y no tiene cuentas, se pide el saldo inicial.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../accounts/application/accounts_providers.dart';
import '../../auth/application/auth_providers.dart';

/// Contenido de una página del tutorial.
class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Páginas del tutorial, en orden.
///
/// Es una función y no una constante porque los textos dependen del idioma
/// activo y se resuelven con `AppLocalizations`.
List<_OnboardingPageData> _pages(AppLocalizations l10n) => [
  _OnboardingPageData(
    icon: Icons.account_balance_wallet_outlined,
    title: l10n.onboardingPage1Title,
    description: l10n.onboardingPage1Description,
  ),
  _OnboardingPageData(
    icon: Icons.add_circle_outline_rounded,
    title: l10n.onboardingPage2Title,
    description: l10n.onboardingPage2Description,
  ),
  _OnboardingPageData(
    icon: Icons.donut_large_rounded,
    title: l10n.onboardingPage3Title,
    description: l10n.onboardingPage3Description,
  ),
  _OnboardingPageData(
    icon: Icons.flag_rounded,
    title: l10n.onboardingPage4Title,
    description: l10n.onboardingPage4Description,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.replay = false});

  /// Cuando es `true` se abre desde Ajustes y al terminar se cierra en lugar
  /// de navegar al inicio.
  final bool replay;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  /// Número fijo de páginas del tutorial.
  static const int _pageCount = 4;

  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Marca el tutorial como completado y decide a dónde ir.
  Future<void> _finish() async {
    await ref.read(onboardingCompletedProvider.notifier).complete();
    if (!mounted) return;
    if (widget.replay) {
      context.pop();
      return;
    }

    final loggedIn = ref.read(sessionProvider) != null;
    if (!loggedIn) {
      context.go('/entrar');
      return;
    }

    // Un usuario nuevo termina el tutorial con las cuentas vacías: le pedimos
    // el saldo inicial antes de entrar. Si ya tiene cuentas, va directo.
    // Ante un error de red se asume que ya tiene cuentas para no bloquearlo.
    var hasAccounts = true;
    try {
      hasAccounts = (await ref.read(accountsProvider.future)).isNotEmpty;
    } catch (_) {
      hasAccounts = true;
    }
    if (!mounted) return;
    context.go(hasAccounts ? '/inicio' : '/saldo-inicial');
  }

  /// Avanza a la siguiente página o termina si ya es la última.
  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = _pages(l10n);
    final theme = Theme.of(context);
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  // Logo y acción de la esquina: cerrar (replay) u omitir.
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 26,
                        ),
                      ),
                      const Spacer(),
                      if (widget.replay)
                        IconButton(
                          tooltip: l10n.close,
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close_rounded),
                        )
                      else if (!_isLast)
                        TextButton(
                          onPressed: _finish,
                          child: Text(l10n.skip),
                        ),
                    ],
                  ),
                  // Páginas desplazables horizontalmente.
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pageCount,
                      onPageChanged: (index) => setState(() => _index = index),
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            // En pantallas bajas la página puede desplazarse
                            // verticalmente sin desbordar.
                            return SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight - 32,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Ilustración circular con doble halo.
                                    Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.07),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 146,
                                          height: 146,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: theme
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                          child: Icon(
                                            page.icon,
                                            size: 64,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xxl),
                                    Text(
                                      page.title,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.6,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      page.description,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(color: palette.muted),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Indicadores de página.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < _pageCount; index++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == _index
                                ? theme.colorScheme.primary
                                : palette.border,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _isLast ? l10n.onboardingStart : l10n.onboardingNext,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.onboardingStep(_index + 1, _pageCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.muted,
                    ),
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
