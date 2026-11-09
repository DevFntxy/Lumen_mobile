import 'routes.dart';

/// Ficha de una pantalla del diagrama de sketches.
class ScreenInfo {
  const ScreenInfo({
    required this.id,
    required this.title,
    required this.path,
    required this.next,
  });

  final String id;
  final String title;
  final String path;

  /// IDs de las pantallas a las que se puede ir desde esta (flujo de salida).
  final List<String> next;
}

/// Catálogo de las 22 pantallas con su flujo de navegación tal como aparece
/// en DiagramaDeSketchesLumen.html.
abstract final class ScreenCatalog {
  static const List<ScreenInfo> all = [
    ScreenInfo(id: 'SCR-01', title: 'Splash', path: AppRoutes.splash, next: ['SCR-18', 'SCR-02']),
    ScreenInfo(id: 'SCR-02', title: 'Iniciar sesión', path: AppRoutes.login, next: ['SCR-05', 'SCR-03', 'SCR-04', 'SCR-19']),
    ScreenInfo(id: 'SCR-03', title: 'Crear cuenta', path: AppRoutes.register, next: ['SCR-05', 'SCR-02']),
    ScreenInfo(id: 'SCR-04', title: 'Recuperar contraseña', path: AppRoutes.recovery, next: ['SCR-02']),
    ScreenInfo(id: 'SCR-05', title: 'Inicio', path: AppRoutes.home, next: ['SCR-14', 'SCR-15', 'SCR-07', 'SCR-06', 'SCR-08', 'SCR-17']),
    ScreenInfo(id: 'SCR-06', title: 'Perfil', path: AppRoutes.profile, next: ['SCR-13', 'SCR-05']),
    ScreenInfo(id: 'SCR-07', title: 'Progreso', path: AppRoutes.progress, next: ['SCR-12', 'SCR-17', 'SCR-10']),
    ScreenInfo(id: 'SCR-08', title: 'Códex de personajes', path: AppRoutes.codex, next: ['SCR-09', 'SCR-11', 'SCR-10']),
    ScreenInfo(id: 'SCR-09', title: 'Códex de amenazas', path: AppRoutes.bestiary, next: ['SCR-11', 'SCR-08']),
    ScreenInfo(id: 'SCR-10', title: 'Logros', path: AppRoutes.achievements, next: ['SCR-11', 'SCR-07', 'SCR-05']),
    ScreenInfo(id: 'SCR-11', title: 'Fragmentos de memoria', path: AppRoutes.memories, next: ['SCR-08', 'SCR-05']),
    ScreenInfo(id: 'SCR-12', title: 'Mapa de zonas', path: AppRoutes.zoneMap, next: ['SCR-07', 'SCR-15', 'SCR-05']),
    ScreenInfo(id: 'SCR-13', title: 'Ajustes', path: AppRoutes.settings, next: ['SCR-06', 'SCR-21', 'SCR-22', 'SCR-05']),
    ScreenInfo(id: 'SCR-14', title: 'Inventario', path: AppRoutes.inventory, next: ['SCR-16', 'SCR-05']),
    ScreenInfo(id: 'SCR-15', title: 'Misiones', path: AppRoutes.quests, next: ['SCR-07', 'SCR-12', 'SCR-05']),
    ScreenInfo(id: 'SCR-16', title: 'Habilidades', path: AppRoutes.skills, next: ['SCR-14', 'SCR-15', 'SCR-05']),
    ScreenInfo(id: 'SCR-17', title: 'Ránking', path: AppRoutes.leaderboard, next: ['SCR-10', 'SCR-05']),
    ScreenInfo(id: 'SCR-18', title: 'Carga', path: AppRoutes.loading, next: ['SCR-05', 'SCR-12']),
    ScreenInfo(id: 'SCR-19', title: 'Cuenta bloqueada', path: AppRoutes.lock, next: ['SCR-20', 'SCR-02']),
    ScreenInfo(id: 'SCR-20', title: 'Desbloquear cuenta', path: AppRoutes.unlock, next: ['SCR-02', 'SCR-05']),
    ScreenInfo(id: 'SCR-21', title: 'Acerca del software', path: AppRoutes.aboutSoftware, next: ['SCR-13', 'SCR-22', 'SCR-05']),
    ScreenInfo(id: 'SCR-22', title: 'Acerca del equipo', path: AppRoutes.aboutTeam, next: ['SCR-21', 'SCR-13', 'SCR-05']),
  ];

  /// Pantallas ya construidas. Al terminar cada una, se agrega aquí su ID y
  /// se registra su ruta en app_router.dart.
  static const Set<String> implemented = {'SCR-01', 'SCR-02', 'SCR-18'};

  static ScreenInfo byId(String id) => all.firstWhere((s) => s.id == id);

  static Iterable<ScreenInfo> get pending =>
      all.where((s) => !implemented.contains(s.id));
}
