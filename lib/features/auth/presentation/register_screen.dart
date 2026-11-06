// Archivo: lib/features/auth/presentation/register_screen.dart
//
// Pantalla de creación de cuenta. Recoge nombre, correo, contraseña y su
// confirmación; luego llama al repositorio de autenticación.
//
// Si el proyecto exige confirmar el correo, Supabase no devuelve sesión y se
// muestra un aviso para que el usuario revise su bandeja.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../application/auth_providers.dart';
import '../data/auth_repository.dart';
import 'auth_error_messages.dart';
import 'auth_scaffold.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(authRepositoryProvider);
    if (repository == null) {
      setState(() => _error = context.l10n.cloudNotConfigured);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final session = await repository.signUp(
        fullName: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;

      // Sin sesión = el proyecto pide confirmar el correo antes de entrar.
      if (session == null) {
        final l10n = context.l10n;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.confirmEmailTitle),
            content: Text(l10n.confirmEmailMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.understood),
              ),
            ],
          ),
        );
        if (!mounted) return;
        context.pop();
        return;
      }

      // Con sesión automática se continúa con el saldo inicial.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.accountReady)),
        );
      context.go('/saldo-inicial');
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.error.message(context.l10n));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return AuthScaffold(
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      // `Wrap` permite que el texto y el botón pasen a otra línea si el
      // idioma activo ocupa más espacio.
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            l10n.registerHaveAccount,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.muted),
          ),
          TextButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/entrar'),
            child: Text(l10n.registerLogin),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.nameLabel,
                hintText: l10n.nameHint,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return l10n.nameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.emailLabel,
                hintText: l10n.emailHint,
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return l10n.emailRequired;
                if (!text.contains('@') || !text.contains('.')) {
                  return l10n.emailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.passwordLabel,
                helperText: l10n.passwordHelper,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscure
                      ? l10n.showPassword
                      : l10n.hidePassword,
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                final text = value ?? '';
                if (text.isEmpty) return l10n.passwordCreateRequired;
                if (text.length < 6) return l10n.passwordTooShort;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _confirm,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.confirmPasswordLabel,
                prefixIcon: const Icon(Icons.lock_reset_rounded),
              ),
              validator: (value) {
                if (value != _password.text) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              AuthErrorText(_error!),
            ],
            const SizedBox(height: AppSpacing.xl),
            AuthSubmitButton(
              label: l10n.registerSubmit,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.registerTerms,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: palette.muted),
            ),
          ],
        ),
      ),
    );
  }
}
