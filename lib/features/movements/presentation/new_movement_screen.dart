// Archivo: lib/features/movements/presentation/new_movement_screen.dart
//
// Formulario para registrar un gasto o un ingreso.
//
// Flujo:
// 1. El usuario elige el tipo (Gasto/Ingreso).
// 2. Escribe el monto, elige cuenta y, opcionalmente, categoría y nota.
// 3. Puede cambiar la fecha (no futura).
// 4. Al guardar se inserta en Supabase y se invalidan cuentas, movimientos y
//    totales para que Inicio y la lista se actualicen.
//
// El ahorro no aparece aquí: necesita una meta, que llega en la Parte 3.

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
import '../../accounts/application/accounts_providers.dart';
import '../../accounts/data/account.dart';
import '../../accounts/data/accounts_repository.dart';
import '../../accounts/presentation/accounts_error_messages.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/data/categories_repository.dart';
import '../../categories/data/category.dart';
import '../../categories/presentation/categories_error_messages.dart';
import '../../categories/presentation/category_labels.dart';
import '../application/movements_providers.dart';
import '../data/movement.dart';
import '../data/movements_repository.dart';
import 'movement_labels.dart';
import 'movements_error_messages.dart';

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

  /// Cambia entre gasto e ingreso. Se limpia la categoría porque las
  /// categorías de gasto no aplican a un ingreso (y viceversa).
  void _changeType(MovementType type) {
    if (type == _type) return;
    setState(() {
      _type = type;
      _categoryId = null;
      _error = null;
    });
  }

  /// Abre el calendario. No permite fechas futuras para no registrar
  /// movimientos que todavía no ocurrieron.
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateUtils.dateOnly(DateTime.now()),
      helpText: context.l10n.datePickerHelp,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = DateUtils.dateOnly(picked));
  }

  /// Valida y guarda el movimiento.
  Future<void> _submit() async {
    final l10n = context.l10n;
    // Se cierra el teclado para que el usuario vea el resultado.
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    // La cuenta no es un campo de `Form`, así que se valida aparte con un
    // mensaje distinto según el tipo.
    if (_accountId == null) {
      setState(
        () => _error = _type == MovementType.gasto
            ? l10n.accountExpenseRequired
            : l10n.accountIncomeRequired,
      );
      return;
    }

    final repository = ref.read(movementsRepositoryProvider);
    if (repository == null) {
      setState(() => _error = l10n.cloudNotConfigured);
      return;
    }

    final amount = MoneyFormat.tryParse(_amount.text);
    if (amount == null) return;

    setState(() => _saving = true);
    // Se capturan antes del `await` para no usar el contexto después de un
    // posible desmontaje.
    final messenger = ScaffoldMessenger.of(context);
    final successMessage = _type.savedMessage(l10n);

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
      // Refresca todo lo que depende de este movimiento.
      ref.invalidate(accountsProvider);
      ref.invalidate(movementsProvider);
      ref.invalidate(monthlyTotalsProvider);
      if (!mounted) return;
      context.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(successMessage)));
    } on MovementsFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.error.message(l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final palette = context.palette;

    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final accounts = accountsAsync.value ?? const <AccountSummary>[];

    // Solo se muestran las categorías del tipo elegido.
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
                // Cabecera con botón volver.
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: l10n.back,
                      onTap: _saving ? () {} : () => context.pop(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.newMovementTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Selector Gasto / Ingreso.
                SegmentedSelector<MovementType>(
                  options: [
                    SegmentedOption(
                      value: MovementType.gasto,
                      label: MovementType.gasto.label(l10n),
                    ),
                    SegmentedOption(
                      value: MovementType.ingreso,
                      label: MovementType.ingreso.label(l10n),
                    ),
                  ],
                  value: _type,
                  onChanged: _changeType,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Monto.
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
                  decoration: InputDecoration(
                    labelText: l10n.amountLabel,
                    hintText: l10n.amountHint,
                    prefixText: 'RD\$ ',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return l10n.amountRequired;
                    final amount = MoneyFormat.tryParse(text);
                    if (amount == null) return l10n.amountInvalid;
                    if (amount <= 0) return l10n.amountPositive;
                    if (amount > 999999999999.99) {
                      return l10n.amountTooLarge;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Cuenta de origen/destino.
                _SectionLabel(l10n.accountQuestion),
                const SizedBox(height: AppSpacing.xs),
                if (accountsAsync.isLoading && accounts.isEmpty)
                  const _InlineLoader()
                else if (accountsAsync.hasError && accounts.isEmpty)
                  _InlineError(
                    message: accountsAsync.error is AccountsFailure
                        ? (accountsAsync.error as AccountsFailure).error.message(
                            l10n,
                          )
                        : l10n.accountsLoadError,
                    onRetry: () => ref.invalidate(accountsProvider),
                  )
                else if (accounts.isEmpty)
                  // Sin cuentas no se puede registrar nada: se guía al saldo
                  // inicial.
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          l10n.firstSetInitialBalance,
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          l10n.needAccountMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: palette.muted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextButton(
                          onPressed: () => context.push('/saldo-inicial'),
                          child: Text(l10n.homeConfigureInitialBalance),
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

                // Categoría opcional. El chip "Sin categoría" deja el campo en
                // null.
                _SectionLabel(l10n.categoryOptional),
                const SizedBox(height: AppSpacing.xs),
                if (categoriesAsync.isLoading && categories.isEmpty)
                  const _InlineLoader()
                else if (categoriesAsync.hasError && categories.isEmpty)
                  _InlineError(
                    message: categoriesAsync.error is CategoriesFailure
                        ? (categoriesAsync.error as CategoriesFailure).error
                              .message(l10n)
                        : l10n.categoriesLoadError,
                    onRetry: () => ref.invalidate(categoriesProvider),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _SelectChip(
                        label: l10n.noCategory,
                        selected: _categoryId == null,
                        onSelected: () => setState(() => _categoryId = null),
                      ),
                      for (final category in categories)
                        _SelectChip(
                          label: category.displayName(l10n),
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

                // Fecha: se muestra como tarjeta pulsable.
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
                              l10n.dateLabel,
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

                // Nota libre, limitada a 200 caracteres.
                TextFormField(
                  controller: _note,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  decoration: InputDecoration(
                    labelText: l10n.noteLabel,
                    hintText: l10n.noteHint,
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _ErrorBox(_error!),
                ],
                const SizedBox(height: AppSpacing.xl),

                // Botón de guardado; el texto depende del tipo.
                FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_type.saveLabel(l10n)),
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

/// Etiqueta pequeña encima de un grupo de chips.
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

/// Chip de selección usado para cuentas y categorías.
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

/// Indicador de carga pequeño para bloques dentro del formulario.
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

/// Error en línea con botón "Reintentar".
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
        TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
      ],
    );
  }
}

/// Caja de error general del formulario.
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
