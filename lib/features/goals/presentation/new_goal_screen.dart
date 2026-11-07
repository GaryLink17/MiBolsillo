// Archivo: lib/features/goals/presentation/new_goal_screen.dart
//
// Formulario para crear una meta de ahorro.
//
// Flujo:
// 1. El usuario escribe un nombre (máximo 60 caracteres) y el monto objetivo.
// 2. Opcionalmente elige una fecha objetivo; no se permiten fechas pasadas.
// 3. Al guardar se inserta en Supabase y se invalida `goalsProvider` para que
//    "Cuentas y metas" muestre la meta nueva al volver.

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
import '../application/goals_providers.dart';
import '../data/goals_repository.dart';
import '../data/savings_goal.dart';
import 'goals_error_messages.dart';

class NewGoalScreen extends ConsumerStatefulWidget {
  const NewGoalScreen({super.key});

  @override
  ConsumerState<NewGoalScreen> createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends ConsumerState<NewGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _target = TextEditingController();

  DateTime? _targetDate;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  /// Abre el calendario desde hoy en adelante.
  ///
  /// La fecha es opcional: si el usuario cancela se conserva la que tuviera.
  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 50),
      helpText: context.l10n.goalDatePickerHelp,
    );
    if (picked == null || !mounted) return;
    setState(() => _targetDate = DateUtils.dateOnly(picked));
  }

  /// Valida y guarda la meta.
  Future<void> _submit() async {
    final l10n = context.l10n;
    // Se cierra el teclado para que el usuario vea el resultado.
    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    // La fecha no es un campo de `Form`, así que se valida aparte. El
    // seleccionador ya limita el rango, pero se comprueba de nuevo por si el
    // formulario se abrió antes de medianoche.
    final today = DateUtils.dateOnly(DateTime.now());
    if (_targetDate != null && _targetDate!.isBefore(today)) {
      setState(() => _error = l10n.goalDatePast);
      return;
    }

    final repository = ref.read(goalsRepositoryProvider);
    if (repository == null) {
      setState(() => _error = l10n.cloudNotConfigured);
      return;
    }

    final amount = MoneyFormat.tryParse(_target.text);
    if (amount == null) return;

    setState(() => _saving = true);
    // Se capturan antes del `await` para no usar el contexto después de un
    // posible desmontaje.
    final messenger = ScaffoldMessenger.of(context);

    try {
      await repository.create(
        GoalDraft(
          name: _name.text.trim(),
          targetAmount: amount,
          targetDate: _targetDate,
        ),
      );
      // Fuerza a "Cuentas y metas" a leer la meta recién creada.
      ref.invalidate(goalsProvider);
      if (!mounted) return;
      context.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.goalSaved)));
    } on GoalsFailure catch (failure) {
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

    return Scaffold(
      body: AppPage(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppPageMetrics.pagePadding,
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
                      l10n.goalNewTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Nombre de la meta.
              TextFormField(
                key: const ValueKey('goal-name'),
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                decoration: InputDecoration(
                  labelText: l10n.goalNameLabel,
                  hintText: l10n.goalNameHint,
                  counterText: '',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return l10n.goalNameRequired;
                  if (text.length > 60) return l10n.goalNameTooLong;
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Monto objetivo.
              TextFormField(
                key: const ValueKey('goal-target'),
                controller: _target,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 34),
                decoration: InputDecoration(
                  labelText: l10n.goalTargetLabel,
                  hintText: l10n.amountHint,
                  prefixText: 'RD\$ ',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return l10n.goalTargetRequired;
                  final amount = MoneyFormat.tryParse(text);
                  if (amount == null) return l10n.goalTargetInvalid;
                  if (amount <= 0) return l10n.goalTargetPositive;
                  if (amount > 999999999999.99) {
                    return l10n.goalTargetTooLarge;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Fecha objetivo opcional.
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
                            l10n.goalDateOptional,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: palette.muted,
                            ),
                          ),
                          Text(
                            _targetDate == null
                                ? l10n.goalNoDate
                                : MaterialLocalizations.of(context)
                                      .formatMediumDate(_targetDate!),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    // Solo se ofrece quitar la fecha cuando ya hay una.
                    if (_targetDate != null)
                      IconButton(
                        tooltip: l10n.goalClearDate,
                        onPressed: _saving
                            ? null
                            : () => setState(() => _targetDate = null),
                        icon: const Icon(Icons.close_rounded),
                      )
                    else
                      Icon(Icons.chevron_right_rounded, color: palette.muted),
                  ],
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                _ErrorBox(_error!),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Botón de guardado con indicador mientras se envía.
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.goalSave),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
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
