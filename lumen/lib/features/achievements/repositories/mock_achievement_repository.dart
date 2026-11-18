import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/errors/app_failure.dart';
import '../models/achievement_collection.dart';
import 'achievement_repository.dart';

class MockAchievementRepository implements AchievementRepository {
  MockAchievementRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;
  AchievementCollection _demoCollection = AchievementCollection(
    unlockedTotal: 7,
    total: 24,
    entries: [
      AchievementEntry(
        id: 'city-explorer-1',
        name: 'Explorador urbano I',
        description: 'Explora 5 zonas distintas.',
        progress: 5,
        target: 5,
        reward: '250 XP',
        completedAt: DateTime(2024, 9, 12),
      ),
      AchievementEntry(
        id: 'boss-terminator',
        name: 'Terminator de jefes',
        description: 'Derrota a 3 jefes.',
        progress: 3,
        target: 3,
        reward: '500 XP',
        completedAt: DateTime(2024, 9, 18),
      ),
      AchievementEntry(
        id: 'collector-1',
        name: 'Coleccionista I',
        description: 'Recupera 10 objetos.',
        progress: 10,
        target: 10,
        reward: '100 créditos',
        completedAt: DateTime(2024, 9, 28),
        rewardClaimed: true,
      ),
      const AchievementEntry(
        id: 'secret-agent',
        name: 'Agente secreto',
        description: 'Encuentra registros ocultos.',
        progress: 1,
        target: 10,
        reward: 'Marco de perfil',
      ),
      AchievementEntry(
        id: 'city-explorer-2',
        name: 'Explorador urbano II',
        description: 'Descubre todos los sectores.',
        progress: 8,
        target: 8,
        reward: '750 XP',
        completedAt: DateTime(2024, 10, 2),
      ),
      AchievementEntry(
        id: 'collector-2',
        name: 'Coleccionista II',
        description: 'Recupera 20 objetos.',
        progress: 20,
        target: 20,
        reward: '200 créditos',
        completedAt: DateTime(2024, 10, 5),
      ),
      AchievementEntry(
        id: 'first-contact',
        name: 'Primer contacto',
        description: 'Identifica tu primera unidad.',
        progress: 1,
        target: 1,
        reward: '100 XP',
        completedAt: DateTime(2024, 10, 8),
      ),
      AchievementEntry(
        id: 'first-mission',
        name: 'Primera misión',
        description: 'Completa tu primera misión.',
        progress: 1,
        target: 1,
        reward: '100 XP',
        completedAt: DateTime(2024, 10, 10),
      ),
      const AchievementEntry(
        id: 'survivor',
        name: 'Superviviente',
        description: 'Completa 5 misiones sin retirarte.',
        progress: 3,
        target: 5,
        reward: 'Insignia de superviviente',
      ),
    ],
  );

  @override
  Future<AchievementCollection> fetchAchievements({
    required String userId,
  }) async {
    await Future<void>.delayed(_latency);
    return userId == MockData.demoUserId
        ? _demoCollection
        : const AchievementCollection.empty();
  }

  @override
  Future<AchievementCollection> claimReward({
    required String userId,
    required String achievementId,
  }) async {
    await Future<void>.delayed(_latency);
    if (userId != MockData.demoUserId) {
      throw const RuleFailure('No hay recompensas disponibles para esta cuenta.');
    }

    final index = _demoCollection.entries.indexWhere(
      (entry) => entry.id == achievementId,
    );
    if (index < 0) throw const RuleFailure('No se encontró el logro.');
    final entry = _demoCollection.entries[index];
    if (!entry.isComplete) {
      throw const RuleFailure('Completa el logro antes de reclamarlo.');
    }
    if (entry.rewardClaimed) {
      throw const RuleFailure('Esta recompensa ya fue reclamada.');
    }

    final entries = [..._demoCollection.entries];
    entries[index] = entry.copyWith(rewardClaimed: true);
    _demoCollection = _demoCollection.copyWith(entries: entries);
    return _demoCollection;
  }
}
