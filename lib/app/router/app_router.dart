// Archivo: lib/app/router/app_router.dart
//
// Define todas las rutas de la app y las reglas de navegación.
//
// La decisión de qué pantalla mostrar depende de dos cosas:
// 1. Si hay una sesión activa (`sessionProvider`).
// 2. Si el tutorial inicial ya se completó (preferencia local).
//
// Las rutas internas viven dentro de un `StatefulShellRoute` para conservar el
// estado de cada pestaña (Inicio, Movimientos, Cuentas, Categorías) mientras se
// navega entre ellas.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/preferences/app_preferences.dart';
import '../../features/accounts/presentation/initial_balance_screen.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/movements/presentation/movements_screen.dart';
import '../../features/movements/presentation/new_movement_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/placeholder/presentation/placeholder_screens.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

/// Avisa al router cuando la sesión cambia (entrar o salir) para que vuelva a
/// evaluar las redirecciones sin recrear el `GoRouter`.
class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(Ref ref) {
    // `ref.listen` no reconstruye este objeto; solo dispara `notifyListeners`
    // para que GoRouter vuelva a ejecutar `redirect`.
    ref.listen<Session?>(sessionProvider, (_, _) => notifyListeners());
  }
}

final _sessionRefreshProvider = Provider<_SessionRefresh>((ref) {
  final refresh = _SessionRefresh(ref);
  ref.onDispose(refresh.dispose);
  return refresh;
});

/// Rutas de la app.
///
/// Orden de entrada: bienvenida → tutorial (solo la primera vez) → acceso.
/// Con sesión, el tutorial pendiente se muestra una vez y luego se entra al
/// inicio. Sin sesión no se puede llegar a ninguna pantalla interna.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_sessionRefreshProvider);

  return GoRouter(
    initialLocation: '/inicio',
    refreshListenable: refresh,
    redirect: (context, state) {
      // `read` es suficiente: el router se reconstruye cuando la sesión cambia
      // gracias a `refreshListenable`.
      final loggedIn = ref.read(sessionProvider) != null;
      final preferences = ref.read(sharedPreferencesProvider);
      final onboardingDone =
          preferences.getBool(PreferenceKeys.onboardingCompleted) ?? false;

      final location = state.matchedLocation;
      final isAuthRoute = location == '/entrar' || location == '/crear-cuenta';
      final isOnboarding = location == '/onboarding';
      final isWelcome = location == '/bienvenida';

      // Sin sesión: primero el tutorial (si falta) y luego el acceso. Las
      // pantallas de bienvenida y tutorial son las únicas permitidas antes de
      // terminar el onboarding.
      if (!loggedIn) {
        if (isAuthRoute) return null;
        if (!onboardingDone) {
          return (isWelcome || isOnboarding) ? null : '/bienvenida';
        }
        return '/entrar';
      }

      // Con sesión pero sin tutorial: se fuerza el tutorial una vez.
      if (!onboardingDone) {
        return isOnboarding ? null : '/onboarding';
      }

      // Con sesión y tutorial completos, las pantallas de acceso y bienvenida
      // ya no tienen sentido: se vuelve al inicio.
      if (isAuthRoute || isWelcome) return '/inicio';
      return null;
    },
    routes: [
      // Pantalla de presentación (sin sesión).
      GoRoute(
        path: '/bienvenida',
        builder: (context, state) => const WelcomeScreen(),
      ),
      // Tutorial. `state.extra == true` indica que se abre desde Ajustes para
      // volver a verlo; en ese caso al terminar se cierra en lugar de navegar.
      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>
            OnboardingScreen(replay: state.extra == true),
      ),
      GoRoute(
        path: '/ajustes',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/entrar',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/crear-cuenta',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Configuración inicial del dinero disponible por cuenta.
      GoRoute(
        path: '/saldo-inicial',
        builder: (context, state) => const InitialBalanceScreen(),
      ),
      // Formulario para registrar un gasto o un ingreso.
      GoRoute(
        path: '/nuevo-movimiento',
        builder: (context, state) => const NewMovementScreen(),
      ),

      // Contenedor de las cuatro pestañas principales. `indexedStack` conserva
      // el estado de cada rama al cambiar de pestaña.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inicio',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/movimientos',
                builder: (context, state) => const MovementsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cuentas',
                builder: (context, state) => const AccountsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categorias',
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // Cualquier ruta inexistente muestra un mensaje en lugar de una pantalla
    // en blanco.
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No encontramos esa pantalla: ${state.uri}')),
    ),
  );
});
