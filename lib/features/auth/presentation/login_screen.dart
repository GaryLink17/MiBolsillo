// Archivo: lib/features/auth/presentation/login_screen.dart
//
// Pantalla de acceso con correo y contraseña. Valida el formulario, llama al
// repositorio de autenticación y muestra los errores en el propio formulario.

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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    // Liberar los controladores evita fugas de memoria.
    _email.dispose();
    _password.dispose();
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
      await repository.signIn(email: _email.text, password: _password.text);
      if (!mounted) return;
      // Si la pantalla se abrió desde otra (por ejemplo Ajustes), se vuelve a
      // ella; si es la raíz, se navega al inicio.
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/inicio');
      }
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
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      // `Wrap` en lugar de `Row`: en inglés el texto es más largo y puede
      // necesitar pasar a una segunda línea en pantallas estrechas.
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            l10n.loginNoAccount,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.muted),
          ),
          TextButton(
            onPressed: () => context.push('/crear-cuenta'),
            child: Text(l10n.loginCreateOne),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                // Validación ligera: la comprobación real la hace Supabase.
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
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.passwordLabel,
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
                if ((value ?? '').isEmpty) return l10n.passwordRequired;
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              AuthErrorText(_error!),
            ],
            const SizedBox(height: AppSpacing.xl),
            AuthSubmitButton(
              label: l10n.loginSubmit,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
