class TeamMember {
  const TeamMember({
    required this.name,
    required this.role,
    required this.github,
  });

  final String name;
  final String role;
  final String github;
}

class FeatureInfo {
  const FeatureInfo({required this.title, required this.detail});

  final String title;
  final String detail;
}

abstract final class AboutContent {
  static const String projectName = 'LUMEN: Crónicas de una Ciudad Olvidada';
  static const String appName = 'Terminal Codex';
  static const String studioName = 'DIMATREK';
  static const String repository = 'github.com/DevFntxy/Lumen';
  static const String gameEngine = 'Unity 6 (C#)';
  static const String gamePlatform = 'Windows 10 y 11 (64 bits)';
  static const String appFramework = 'Flutter (Dart)';
  static const String leadDeveloper = 'Derek Sesni';
  static const String leadDeveloperRole = 'Lead Programmer / Game Designer';

  static const List<FeatureInfo> features = [
    FeatureInfo(
      title: 'Progreso e inventario',
      detail: 'Consulta el avance, las misiones y los objetos de demostración. '
          'La sincronización con el juego aún no está conectada.',
    ),
    FeatureInfo(
      title: 'Códex',
      detail: 'Explora fichas de personajes, amenazas y fragmentos narrativos '
          'incluidos en esta versión demo.',
    ),
    FeatureInfo(
      title: 'Habilidades y logros',
      detail: 'Revisa habilidades y logros de ejemplo; los datos se conservan '
          'en memoria durante la sesión.',
    ),
    FeatureInfo(
      title: 'Efecto CRT',
      detail: 'Activa o desactiva las líneas de escaneo en Ajustes.',
    ),
    FeatureInfo(
      title: 'Acceso de demostración',
      detail: 'La autenticación y la recuperación de cuenta se ejecutan con '
          'un repositorio mock local.',
    ),
  ];

  static const List<TeamMember> team = [
    TeamMember(
      name: 'Erick Matias',
      role: 'Project Manager / Compositor musical secundario',
      github: 'EMATIAS230045',
    ),
    TeamMember(
      name: 'Derek Sesni',
      role: 'Lead Programmer / Game Designer',
      github: 'DevFntxy',
    ),
    TeamMember(
      name: 'Diego Rivera',
      role: 'Artista 2D / 3D / Compositor musical principal',
      github: 'DiegoMiguel04',
    ),
    TeamMember(
      name: 'José García',
      role: 'Documentador principal / Tester QA',
      github: 'ppyo1234',
    ),
  ];

  static const String mission = 'Desarrollar un videojuego de aventura y '
      'exploración en tercera dimensión donde el jugador investiga una ciudad '
      'industrial abandonada, resuelve desafíos, enfrenta enemigos y descubre '
      'su historia mediante narrativa ambiental y sistemas de progresión.';

  static const List<String> tools = [
    'Unity',
    'Blender',
    'FMOD Studio',
    'LMMS',
    'Cakewalk',
    'Jira',
    'Git y GitHub',
    'Flutter',
  ];
}
