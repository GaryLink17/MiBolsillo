import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/preferences/app_preferences.dart';

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

const _pages = [
  _OnboardingPageData(
    icon: Icons.account_balance_wallet_outlined,
    title: 'Todo tu dinero, en un solo lugar',
    description: 'Consulta tu balance, tus cuentas y tus metas de ahorro de forma clara y sin complicaciones.',
  ),
  _OnboardingPageData(
    icon: Icons.add_circle_outline_rounded,
    title: 'Registra en segundos',
    description: 'Toca el botón + para anotar un gasto, un ingreso o un ahorro. Solo eliges el monto, la cuenta y la categoría.',
  ),
  _OnboardingPageData(
    icon: Icons.donut_large_rounded,
    title: 'Entiende en qué gastas',
    description: 'Revisa tus gastos por categoría y descubre dónde puedes ajustar para llegar más lejos.',
  ),
  _OnboardingPageData(
    icon: Icons.flag_rounded,
    title: 'Ahorra con propósito',
    description: 'Crea metas como tus vacaciones o un fondo de emergencia y mira cómo avanzas cada mes.',
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
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingCompletedProvider.notifier).complete();
    if (!mounted) return;
    if (widget.replay) {
      context.pop();
    } else {
      context.go('/inicio');
    }
  }

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
                          tooltip: 'Cerrar',
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close_rounded),
                        )
                      else if (!_isLast)
                        TextButton(
                          onPressed: _finish,
                          child: const Text('Omitir'),
                        ),
                    ],
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (index) => setState(() => _index = index),
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight - 32,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < _pages.length; index++)
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
                    child: Text(_isLast ? 'Empezar' : 'Siguiente'),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Paso ${_index + 1} de ${_pages.length}',
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
