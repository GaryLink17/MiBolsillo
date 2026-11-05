// Archivo: lib/features/shell/presentation/app_shell.dart
//
// Contenedor de las pestañas principales. GoRouter entrega un
// `StatefulNavigationShell` que conserva el estado de cada rama y sabe cuál
// está activa.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // Si se toca la pestaña ya activa, `initialLocation: true` vuelve a
          // su pantalla raíz (por ejemplo, salir de un detalle).
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        // El botón "+" abre el formulario como pantalla aparte, no como rama.
        onAddPressed: () => context.push('/nuevo-movimiento'),
      ),
    );
  }
}
