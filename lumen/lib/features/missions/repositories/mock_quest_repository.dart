import '../../../app/config/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../models/quest.dart';
import 'quest_repository.dart';

class MockQuestRepository implements QuestRepository {
  MockQuestRepository({Duration? latency})
    : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;
  final Map<String, List<Quest>> _questsByUser = {};

  static const List<Quest> _demoQuests = [
    Quest(
      id: 'dragon-bane',
      title: 'La perdición del dragón ancestral',
      progress: 4,
      target: 5,
      location: 'Cumbre ígnea',
      reward: '250 chatarra',
    ),
    Quest(
      id: 'galaxy-gem',
      title: 'Recolector de gema azul',
      progress: 2,
      target: 5,
      location: 'Campo de asteroides',
      reward: '1 núcleo azul',
    ),
    Quest(
      id: 'captain-blackbeard',
      title: 'Se busca: Capitán Blackbeard',
      progress: 1,
      target: 5,
      location: 'Galaxia Nebulosa',
      reward: '500 chatarra',
    ),
    Quest(
      id: 'forging-materials',
      title: 'Materiales de forja del gremio',
      progress: 6,
      target: 10,
      location: 'Fabricación',
      reward: 'Plano de reparación',
    ),
    Quest(
      id: 'reactivate-terminal',
      title: 'Reactivar terminal de la fábrica',
      progress: 3,
      target: 3,
      location: 'Fábrica hundida',
      reward: '150 chatarra',
    ),
  ];

  Future<void> _wait() => Future<void>.delayed(_latency);

  @override
  Future<List<Quest>> fetchQuests({required String userId}) async {
    await _wait();
    if (userId != MockData.demoUserId) return const [];
    return List.unmodifiable(_getQuests(userId));
  }

  @override
  Future<void> claimReward({
    required String userId,
    required String questId,
  }) async {
    await _wait();
    if (userId != MockData.demoUserId) {
      throw const UnknownFailure('No encontramos la misión para esta cuenta.');
    }

    final quests = _getQuests(userId);
    final index = quests.indexWhere((quest) => quest.id == questId);
    if (index < 0) {
      throw const UnknownFailure('No encontramos la misión seleccionada.');
    }

    final quest = quests[index];
    if (!quest.isComplete) {
      throw const UnknownFailure('Completa la misión antes de reclamarla.');
    }
    if (quest.rewardClaimed) {
      throw const UnknownFailure('La recompensa ya fue reclamada.');
    }
    quests[index] = quest.copyWith(rewardClaimed: true);
  }

  List<Quest> _getQuests(String userId) =>
      _questsByUser.putIfAbsent(userId, () => List.of(_demoQuests));
}
