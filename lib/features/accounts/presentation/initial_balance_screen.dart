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
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/money_text.dart';
import '../application/accounts_providers.dart';
import '../data/account.dart';
import '../data/accounts_repository.dart';

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
    if (!_formKey.currentState!.validate()) return;

    final selected = _drafts.where((draft) => draft.enabled).toList();
    if (selected.isEmpty) {
      setState(() => _error = 'Activa al menos una cuenta.');
      return;
    }

    final repository = ref.read(accountsRepositoryProvider);
    if (repository == null) {
      setState(() => _error = 'La nube no está configurada en esta versión.');
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
            name: draft.kind.label,
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
          const SnackBar(content: Text('Tus cuentas están listas.')),
        );
      context.go('/inicio');
    } on AccountsFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.message);
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
                    child: const Text('Omitir'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '¿Con cuánto empiezas?',
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Escribe lo que tienes hoy en cada cuenta. Si alguna no la '
                'usas, desactívala.',
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
                        'Tu saldo total',
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
                    : const Text('Empezar'),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: _saving ? null : _skip,
                child: const Text('Lo hago después'),
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
                  draft.kind.label,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                'Usar',
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
              decoration: const InputDecoration(
                labelText: 'Saldo actual',
                hintText: '0.00',
                prefixText: 'RD\$ ',
                isDense: true,
              ),
              validator: (value) {
                // Vacío significa cero: es válido no tener dinero en una
                // cuenta activa.
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                final amount = MoneyFormat.tryParse(text);
                if (amount == null) return 'Escribe un monto válido.';
                if (amount < 0) return 'El monto no puede ser negativo.';
                if (amount > 999999999999) {
                  return 'Ese monto es demasiado grande.';
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
