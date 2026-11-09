import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/loading_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import 'placeholder_screen.dart';
import 'routes.dart';
import 'screen_catalog.dart';

/// Transición corta de fundido para todas las pantallas.
CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  // Avisa al router cuando cambia la sesión para que reevalúe `redirect`.
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authControllerProvider, (previous, next) {
    refresh.value++;
  });

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final path = state.matchedLocation;
      final isPublic = AppRoutes.publicPaths.contains(path);

      // Sin sesión no se entra a rutas privadas.
      if (status != AuthStatus.authenticated && !isPublic) {
        return status == AuthStatus.unknown ? AppRoutes.splash : AppRoutes.login;
      }
      // Con sesión no se vuelve al login: se pasa a la pantalla de carga.
      if (status == AuthStatus.authenticated && path == AppRoutes.login) {
        return AppRoutes.loading;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _page(state, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _page(state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.loading,
        pageBuilder: (context, state) => _page(state, const LoadingScreen()),
      ),
      for (final info in ScreenCatalog.pending)
        GoRoute(
          path: info.path,
          pageBuilder: (context, state) =>
              _page(state, PlaceholderScreen(info: info)),
        ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
