/// Resumen del avance del jugador en el juego.
class PlayerProgress {
  const PlayerProgress({
    required this.actName,
    required this.actProgress,
    required this.overallCompletion,
    required this.lastSession,
    required this.zonesUnlocked,
    required this.zonesTotal,
    required this.activeQuests,
    required this.codexUnlocked,
    required this.codexTotal,
    required this.achievementsUnlocked,
    required this.achievementsTotal,
  });

  final String actName;

  /// 0.0 a 1.0, dentro del acto actual.
  final double actProgress;

  /// 0.0 a 1.0, de todo el juego.
  final double overallCompletion;
  final DateTime lastSession;
  final int zonesUnlocked;
  final int zonesTotal;
  final int activeQuests;
  final int codexUnlocked;
  final int codexTotal;
  final int achievementsUnlocked;
  final int achievementsTotal;
}
