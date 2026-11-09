/// Rutas de la app. Una por cada pantalla del diagrama de sketches (SCR-xx).
abstract final class AppRoutes {
  static const String splash = '/';
  static const String loading = '/loading';
  static const String login = '/login';
  static const String register = '/register';
  static const String recovery = '/recovery';
  static const String lock = '/lock';
  static const String unlock = '/unlock';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String inventory = '/inventory';
  static const String skills = '/skills';
  static const String quests = '/quests';
  static const String progress = '/progress';
  static const String zoneMap = '/map';
  static const String leaderboard = '/leaderboard';
  static const String codex = '/codex';
  static const String bestiary = '/codex/enemies';
  static const String achievements = '/achievements';
  static const String memories = '/codex/memories';
  static const String aboutSoftware = '/about-software';
  static const String aboutTeam = '/about-team';

  /// Rutas accesibles sin sesión iniciada.
  static const Set<String> publicPaths = {
    splash,
    login,
    register,
    recovery,
    lock,
    unlock,
  };
}
