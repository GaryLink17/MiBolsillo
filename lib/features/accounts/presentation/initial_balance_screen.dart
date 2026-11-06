// Archivo: lib/features/accounts/presentation/initial_balance_screen.dart
//
// Primera configuración del dinero: el usuario indica cuánto tiene en cada tipo
// de cuenta y decide cuáles quiere usar.
//
// Se muestra justo después de crear la cuenta. Antes de pintar el formulario
// comprueba si ya hay cuentas (por ejemplo, si entró desde otro teléfono) para
// no pedir el saldo dos veces.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_page_metrics.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/money_format.dart';
import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../application/accounts_providers.dart';
import '../data/account.dart';
import '../data/accounts_repository.dart';
import 'account_labels.dart';
import 'accounts_error_messages.dart';

/// Primera configuración: cuánto dinero tiene el usuario en cada cuenta.
///
/// Se muestra justo después de crear la cuenta. Solo se guardan las cuentas
/// activadas; las demás quedan fuera para que Inicio no se llene de ceros.
class InitialBalanceScreen extends ConsumerStatefulWidget {
  const InitialBalanceScreen({super.key});

  @override
  ConsumerState<InitialBalanceScreen> createState() =>
      _InitialBalanceScreenState();
}

/// Estado editable de una fila de cuenta en el formulario.
///
/// Mantiene el interruptor, el monto escrito y el controlador del campo. Se
/// crea una instancia por tipo de cuenta.
class _AccountDraft {
  _AccountDraft({required this.kind, required this.enabled});

  final AccountKind kind;
  bool enabled;
  final TextEditingController controller = TextEditingController();

  void dispose() => controller.dispose();
}

class _InitialBalanceScreenState extends ConsumerState<InitialBalanceScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Efectivo y Banco vienen activos; Ahorros y Tarjeta, desactivados. Así el
  /// formulario inicial es corto y el usuario solo enciende lo que usa.
  late final List<_AccountDraft> _drafts = [
    _AccountDraft(kind: AccountKind.efectivo, enabled: true),
    _AccountDraft(kind: AccountKind.banco, enabled: true),
    _AccountDraft(kind: AccountKind.ahorro, enabled: false),
    _AccountDraft(kind: AccountKind.tarjeta, enabled: false),
  ];
  bool _saving = false;
  bool _checking = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Se consulta después del primer frame porque necesita el `ref` montado.
    WidgetsBinding.instance.addPostFrameCallback((_) => _skipIfConfigured());
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  /// Si el usuario ya tiene cuentas (por ejemplo, entró desde otro teléfono),
  /// no le pedimos otra vez el saldo inicial.
  Future<void> _skipIfConfigured() async {
    try {
      final accounts = await ref.read(accountsProvider.future);
      if (!mounted) return;
      if (accounts.isNotEmpty) {
        context.go('/inicio');
        return;
      }
    } catch (_) {
      // Sin conexión seguimos mostrando el formulario; al guardar se avisa.
    }
    if (mounted) setState(() => _checking = false);
  }

  /// Suma en vivo solo las cuentas activas. Se recalcula en cada cambio de
  /// texto para mostrar el "saldo total" antes de guardar.
  double get _total {
    var total = 0.0;
    for (final draft in _drafts) {
      if (!draft.enabled) continue;
      total += MoneyFormat.tryParse(draft.controller.text) ?? 0;
    }
    return total;
  }

  /// Guarda las cuentas activas en Supabase y navega al inicio.
  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;

    final selected = _drafts.where((draft) => draft.enabled).toList();
    if (selected.isEmpty) {
      setState(() => _error = l10n.initialBalanceActivateOne);
      return;
    }

    final repository = ref.read(accountsRepositoryProvider);
    if (repository == null) {
      setState(() => _error = l10n.cloudNotConfigured);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await repository.createInitial([
        for (final draft in selected)
          InitialAccount(
            name: draft.kind.label(l10n),
            kind: draft.kind,
            amount: MoneyFormat.tryParse(draft.controller.text) ?? 0,
          ),
      ]);
      // fuerza a Inicio a leer las cuentas recién creadas.
      ref.invalidate(accountsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.initialBalanceReady)),
        );
      context.go('/inicio');
    } on AccountsFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.error.message(l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Sale del formulario sin guardar. Si se abrió desde otra pantalla vuelve a
  /// ella; si no, va al inicio.
  void _skip() {
    if (_saving) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/inicio');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;

    // Mientras se comprueba si ya hay cuentas se muestra un indicador para no
    // enseñar el formulario por un instante y luego saltar.
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: AppPage(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppPageMetrics.pagePadding,
            children: [
              Row(
                children: [
                  const CircleIcon(
                    icon: Icons.savings_outlined,
                    size: 44,
                    iconSize: 22,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving ? null : _skip,
                    child: Text(l10n.skip),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.initialBalanceTitle,
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.initialBalanceSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Una tarjeta por tipo de cuenta.
              for (var i = 0; i < _drafts.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                _AccountCard(
                  draft: _drafts[i],
                  onEnabledChanged: (enabled) {
                    setState(() => _drafts[i].enabled = enabled);
                  },
                  onAmountChanged: () => setState(() {}),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              // Resumen en vivo del saldo que se va a guardar.
              AppCard(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.45,
                ),
                borderColor: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.initialBalanceTotal,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    MoneyText(
                      _total,
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
                      showDecimals: true,
                    ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                _ErrorBox(_error!),
              ],
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.initialBalanceStart),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: _saving ? null : _skip,
                child: Text(l10n.initialBalanceLater),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de un tipo de cuenta con interruptor y campo de monto.
class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.draft,
    required this.onEnabledChanged,
    required this.onAmountChanged,
  });

  final _AccountDraft draft;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // El icono cambia de color según si la cuenta está activa.
              CircleIcon(
                icon: draft.kind.icon,
                size: 42,
                iconSize: 21,
                background: draft.enabled
                    ? theme.colorScheme.primaryContainer
                    : palette.surfaceAlt,
                foreground: draft.enabled
                    ? theme.colorScheme.onPrimaryContainer
                    : palette.muted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  draft.kind.label(l10n),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                l10n.initialBalanceUse,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Switch(value: draft.enabled, onChanged: onEnabledChanged),
            ],
          ),
          // El monto solo se pide cuando la cuenta está activa.
          if (draft.enabled) ...[
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: draft.controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              onChanged: (_) => onAmountChanged(),
              decoration: InputDecoration(
                labelText: l10n.initialBalanceAmountLabel,
                hintText: l10n.initialBalanceAmountHint,
                prefixText: 'RD\$ ',
                isDense: true,
              ),
              validator: (value) {
                // Vacío significa cero: es válido no tener dinero en una
                // cuenta activa.
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                final amount = MoneyFormat.tryParse(text);
                if (amount == null) return l10n.initialBalanceInvalidAmount;
                if (amount < 0) return l10n.initialBalanceNegative;
                if (amount > 999999999999) {
                  return l10n.initialBalanceTooLarge;
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Caja de error con fondo rojo suave.
class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.dangerBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: palette.danger),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: palette.danger),
            ),
          ),
        ],
      ),
    );
  }
}
