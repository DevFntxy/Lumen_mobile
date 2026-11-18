import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/screens/profile_screen.dart';
import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/loading_screen.dart';
import '../../features/auth/screens/lock_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/password_recovery_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/unlock_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/codex/screens/codex_screen.dart';
import '../../features/codex/screens/threat_codex_screen.dart';
import '../../features/achievements/screens/achievements_screen.dart';
import '../../features/about/screens/about_software_screen.dart';
import '../../features/about/screens/about_team_screen.dart';
import '../../features/inventory/screens/inventory_screen.dart';
import '../../features/leaderboard/screens/leaderboard_screen.dart';
import '../../features/map/screens/zone_map_screen.dart';
import '../../features/memories/screens/memory_fragments_screen.dart';
import '../../features/missions/screens/missions_screen.dart';
import '../../features/player/screens/progress_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/skills/screens/skills_screen.dart';
import '../shell/app_shell.dart';
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

String? _messageFrom(GoRouterState state) {
  final extra = state.extra;
  return extra is String ? extra : null;
}

final routerProvider = Provider<GoRouter>((ref) {
  // Avisa al router cuando cambia la sesión para que reevalúe `redirect`.
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authControllerProvider, (previous, next) {
    refresh.value++;
  });

  final pending = ScreenCatalog.pending.toList();
  final tabPlaceholders =
      pending.where((screen) => AppRoutes.tabPaths.contains(screen.path));
  final otherPlaceholders =
      pending.where((screen) => !AppRoutes.tabPaths.contains(screen.path));

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
      if (status == AuthStatus.authenticated &&
          AppRoutes.guestOnlyPaths.contains(path)) {
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
        pageBuilder: (context, state) =>
            _page(state, LoginScreen(initialMessage: _messageFrom(state))),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _page(state, const RegisterScreen()),
      ),
      GoRoute(
        path: AppRoutes.recovery,
        pageBuilder: (context, state) =>
            _page(state, const PasswordRecoveryScreen()),
      ),
      GoRoute(
        path: AppRoutes.lock,
        pageBuilder: (context, state) => _page(state, const LockScreen()),
      ),
      GoRoute(
        path: AppRoutes.unlock,
        pageBuilder: (context, state) =>
            _page(state, UnlockScreen(initialMessage: _messageFrom(state))),
      ),
      GoRoute(
        path: AppRoutes.loading,
        pageBuilder: (context, state) => _page(state, const LoadingScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _page(state, const HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.quests,
            pageBuilder: (context, state) =>
                _page(state, const MissionsScreen()),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            pageBuilder: (context, state) =>
                _page(state, const InventoryScreen()),
          ),
          GoRoute(
            path: AppRoutes.codex,
            pageBuilder: (context, state) => _page(state, const CodexScreen()),
          ),
          GoRoute(
            path: AppRoutes.leaderboard,
            pageBuilder: (context, state) =>
                _page(state, const LeaderboardScreen()),
          ),
          for (final info in tabPlaceholders)
            GoRoute(
              path: info.path,
              pageBuilder: (context, state) =>
                  _page(state, PlaceholderScreen(info: info)),
            ),
        ],
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => _page(state, const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.progress,
        pageBuilder: (context, state) => _page(state, const ProgressScreen()),
      ),
      GoRoute(
        path: AppRoutes.bestiary,
        pageBuilder: (context, state) =>
            _page(state, const ThreatCodexScreen()),
      ),
      GoRoute(
        path: AppRoutes.achievements,
        pageBuilder: (context, state) =>
            _page(state, const AchievementsScreen()),
      ),
      GoRoute(
        path: AppRoutes.memories,
        pageBuilder: (context, state) =>
            _page(state, const MemoryFragmentsScreen()),
      ),
      GoRoute(
        path: AppRoutes.zoneMap,
        pageBuilder: (context, state) => _page(state, const ZoneMapScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => _page(state, const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.skills,
        pageBuilder: (context, state) => _page(state, const SkillsScreen()),
      ),
      GoRoute(
        path: AppRoutes.aboutSoftware,
        pageBuilder: (context, state) =>
            _page(state, const AboutSoftwareScreen()),
      ),
      GoRoute(
        path: AppRoutes.aboutTeam,
        pageBuilder: (context, state) =>
            _page(state, const AboutTeamScreen()),
      ),
      for (final info in otherPlaceholders)
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
