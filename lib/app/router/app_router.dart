import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/preferences/app_preferences.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/placeholder/presentation/placeholder_screens.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

/// Avisa al router cuando la sesión cambia (entrar o salir) para que vuelva a
/// evaluar las redirecciones sin recrear el `GoRouter`.
class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(Ref ref) {
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
/// Orden de entrada: acceso → tutorial (solo la primera vez) → inicio.
/// Sin sesión no se puede llegar a ninguna pantalla interna.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_sessionRefreshProvider);

  return GoRouter(
    initialLocation: '/inicio',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = ref.read(sessionProvider) != null;
      final preferences = ref.read(sharedPreferencesProvider);
      final onboardingDone =
          preferences.getBool(PreferenceKeys.onboardingCompleted) ?? false;

      final location = state.matchedLocation;
      final isAuthRoute = location == '/entrar' || location == '/crear-cuenta';
      final isOnboarding = location == '/onboarding';
      final isWelcome = location == '/bienvenida';

      if (!loggedIn) {
        if (isAuthRoute) return null;
        if (!onboardingDone) {
          return (isWelcome || isOnboarding) ? null : '/bienvenida';
        }
        return '/entrar';
      }

      if (!onboardingDone) {
        return isOnboarding ? null : '/onboarding';
      }
      if (isAuthRoute || isWelcome) return '/inicio';
      return null;
    },
    routes: [
      GoRoute(
        path: '/bienvenida',
        builder: (context, state) => const WelcomeScreen(),
      ),
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
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No encontramos esa pantalla: ${state.uri}')),
    ),
  );
});
