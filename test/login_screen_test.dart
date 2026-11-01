import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mibolsillo/app/theme/app_theme.dart';
import 'package:mibolsillo/features/auth/application/auth_providers.dart';
import 'package:mibolsillo/features/auth/presentation/login_screen.dart';

Widget _buildLogin() {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(null)],
    child: MaterialApp(
      theme: buildAppTheme(Brightness.light),
      home: const LoginScreen(),
    ),
  );
}

void main() {
  testWidgets('el acceso pide correo y contraseña antes de enviar', (
    tester,
  ) async {
    await tester.pumpWidget(_buildLogin());
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe tu correo.'), findsOneWidget);
    expect(find.text('Escribe tu contraseña.'), findsOneWidget);
  });

  testWidgets('avisa cuando la nube no está configurada', (tester) async {
    await tester.pumpWidget(_buildLogin());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'persona@correo.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'secreto123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(
      find.text('La nube no está configurada en esta versión.'),
      findsOneWidget,
    );
  });
}
