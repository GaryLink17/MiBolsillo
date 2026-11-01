import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../application/auth_providers.dart';
import '../data/auth_repository.dart';
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(authRepositoryProvider);
    if (repository == null) {
      setState(() => _error = 'La nube no está configurada en esta versión.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await repository.signIn(email: _email.text, password: _password.text);
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/inicio');
      }
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AuthScaffold(
      title: 'Bienvenido de nuevo',
      subtitle: 'Entra para tener tus cuentas y movimientos al día.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿No tienes cuenta?',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.muted),
          ),
          TextButton(
            onPressed: () => context.push('/crear-cuenta'),
            child: const Text('Crear una'),
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
              decoration: const InputDecoration(
                labelText: 'Correo',
                hintText: 'tu@correo.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Escribe tu correo.';
                if (!text.contains('@') || !text.contains('.')) {
                  return 'Escribe un correo válido.';
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
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) return 'Escribe tu contraseña.';
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              AuthErrorText(_error!),
            ],
            const SizedBox(height: AppSpacing.xl),
            AuthSubmitButton(
              label: 'Entrar',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
