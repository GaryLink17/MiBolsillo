import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../application/auth_providers.dart';
import '../data/auth_repository.dart';
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
      setState(() => _error = 'La nube no está configurada en esta versión.');
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

      if (session == null) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Revisa tu correo'),
            content: const Text(
              'Te enviamos un enlace para confirmar tu cuenta. '
              'Ábrelo y luego entra desde la pantalla de acceso.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
        if (!mounted) return;
        context.pop();
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Tu cuenta está lista. ¡Bienvenido!')),
        );
      context.go('/inicio');
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
      title: 'Crea tu cuenta',
      subtitle: 'Tus datos quedan privados y sincronizados en tu cuenta.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Ya tienes cuenta?',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.muted),
          ),
          TextButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/entrar'),
            child: const Text('Entrar'),
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
              decoration: const InputDecoration(
                labelText: 'Tu nombre',
                hintText: 'Cómo quieres que te llamemos',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return 'Escribe tu nombre.';
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
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                helperText: 'Mínimo 6 caracteres',
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
                final text = value ?? '';
                if (text.isEmpty) return 'Escribe una contraseña.';
                if (text.length < 6) return 'Usa al menos 6 caracteres.';
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
              decoration: const InputDecoration(
                labelText: 'Repite la contraseña',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
              validator: (value) {
                if (value != _password.text) {
                  return 'Las contraseñas no coinciden.';
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
              label: 'Crear cuenta',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Al crear tu cuenta aceptas que tus datos financieros '
              'se guarden de forma privada en tu espacio.',
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
