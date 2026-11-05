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
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/data/account.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/data/category.dart';
import '../application/movements_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';

/// Registro de un gasto o un ingreso.
///
/// El ahorro no aparece aquí: necesita una meta, que llega con M3.2.
class NewMovementScreen extends ConsumerStatefulWidget {
  const NewMovementScreen({super.key});

  @override
  ConsumerState<NewMovementScreen> createState() => _NewMovementScreenState();
}

class _NewMovementScreenState extends ConsumerState<NewMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();

  MovementType _type = MovementType.gasto;
  String? _accountId;
  String? _categoryId;
  DateTime _date = DateUtils.dateOnly(DateTime.now());
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _changeType(MovementType type) {
    if (type == _type) return;
    setState(() {
      _type = type;
      _categoryId = null;
      _error = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateUtils.dateOnly(DateTime.now()),
      helpText: 'Fecha del movimiento',
    );
    if (picked == null || !mounted) return;
    setState(() => _date = DateUtils.dateOnly(picked));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    if (_accountId == null) {
      setState(
        () => _error = _type == MovementType.gasto
            ? 'Elige la cuenta de donde sale el dinero.'
            : 'Elige la cuenta donde entra el dinero.',
      );
      return;
    }

    final repository = ref.read(movementsRepositoryProvider);
    if (repository == null) {
      setState(() => _error = 'La nube no está configurada en esta versión.');
      return;
    }

    final amount = MoneyFormat.tryParse(_amount.text);
    if (amount == null) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final successMessage = '${_type.label} registrado.';

    try {
      await repository.create(
        MovementDraft(
          type: _type,
          amount: amount,
          occurredOn: _date,
          accountId: _accountId!,
          categoryId: _categoryId,
          note: _note.text,
        ),
      );
      ref.invalidate(accountsProvider);
      if (!mounted) return;
      context.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(successMessage)));
    } on MovementsFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final accounts = accountsAsync.value ?? const <AccountSummary>[];
    final categories = (categoriesAsync.value ?? const <Category>[])
        .where((category) => category.kind == _type.categoryKind)
        .toList(growable: false);

    return Scaffold(
      body: AppPage(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: AppPageMetrics.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Volver',
                      onTap: _saving ? () {} : () => context.pop(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Nuevo movimiento',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SegmentedSelector<MovementType>(
                  options: const [
                    SegmentedOption(value: MovementType.gasto, label: 'Gasto'),
                    SegmentedOption(
                      value: MovementType.ingreso,
                      label: 'Ingreso',
                    ),
                  ],
                  value: _type,
                  onChanged: _changeType,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const ValueKey('movement-amount'),
                  controller: _amount,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 34),
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    hintText: '0.00',
                    prefixText: 'RD\$ ',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Escribe el monto.';
                    final amount = MoneyFormat.tryParse(text);
                    if (amount == null) return 'Escribe un monto válido.';
                    if (amount <= 0) return 'El monto debe ser mayor que cero.';
                    if (amount > 999999999999.99) {
                      return 'Ese monto es demasiado grande.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                const _SectionLabel('¿De qué cuenta?'),
                const SizedBox(height: AppSpacing.xs),
                if (accountsAsync.isLoading && accounts.isEmpty)
                  const _InlineLoader()
                else if (accountsAsync.hasError && accounts.isEmpty)
                  _InlineError(
                    message: 'No pudimos cargar tus cuentas.',
                    onRetry: () => ref.invalidate(accountsProvider),
                  )
                else if (accounts.isEmpty)
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          'Primero configura tu saldo inicial',
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Necesitas al menos una cuenta para registrar '
                          'movimientos.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: palette.muted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextButton(
                          onPressed: () => context.push('/saldo-inicial'),
                          child: const Text('Configurar saldo inicial'),
                        ),
                      ],
                    ),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final account in accounts)
                        _SelectChip(
                          label:
                              '${account.name} · '
                              '${MoneyFormat.withSymbol(account.balance)}',
                          selected: _accountId == account.id,
                          avatar: Icon(
                            account.kind.icon,
                            size: 16,
                            color: palette.muted,
                          ),
                          onSelected: () {
                            setState(() {
                              _accountId = account.id;
                              _error = null;
                            });
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.lg),
                const _SectionLabel('Categoría (opcional)'),
                const SizedBox(height: AppSpacing.xs),
                if (categoriesAsync.isLoading && categories.isEmpty)
                  const _InlineLoader()
                else if (categoriesAsync.hasError && categories.isEmpty)
                  _InlineError(
                    message: 'No pudimos cargar tus categorías.',
                    onRetry: () => ref.invalidate(categoriesProvider),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _SelectChip(
                        label: 'Sin categoría',
                        selected: _categoryId == null,
                        onSelected: () => setState(() => _categoryId = null),
                      ),
                      for (final category in categories)
                        _SelectChip(
                          label: category.name,
                          selected: _categoryId == category.id,
                          avatar: Icon(
                            category.icon,
                            size: 16,
                            color: palette.tone(category.tone).foreground,
                          ),
                          onSelected: () {
                            setState(() => _categoryId = category.id);
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  onTap: _saving ? null : _pickDate,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      const CircleIcon(
                        icon: Icons.event_outlined,
                        size: 42,
                        iconSize: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                            Text(
                              MaterialLocalizations.of(context)
                                  .formatMediumDate(_date),
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: palette.muted),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _note,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  decoration: const InputDecoration(
                    labelText: 'Nota (opcional)',
                    hintText: 'Ej. almuerzo con el equipo',
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
                      : Text(_type.saveLabel),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(color: context.palette.muted),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return ChoiceChip(
      label: Text(label),
      avatar: avatar,
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      selectedColor: theme.colorScheme.primaryContainer,
      backgroundColor: palette.surface,
      side: BorderSide(
        color: selected ? theme.colorScheme.primary : palette.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}

class _InlineLoader extends StatelessWidget {
  const _InlineLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    );
  }
}

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
